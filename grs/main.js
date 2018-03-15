var scheme = undefined;
String.prototype.__ = function()
{
    return this
}
function mailtoMe(prefix)
{
    if(scheme) return;
    // get scheme
    $.get(prefix+"/sendto.html")
    .done(function(d) {
        scheme = $.parseHTML(d)
        var obs = riot.observable()
        $(scheme).css("visibility","hidden")
        $("#desktop" ).append(scheme)
        obs.on("exit", function(){
            $(scheme).remove()
            scheme = undefined
        })
        obs.on("rendered", function(d){
            $(".afx-window-title", scheme).html("Send me an email")
            $("[data-id='send']", scheme).click(function(){
                var status = $("[data-id='status']", scheme)
                status.html("");
                var els = $("[data-class='data']", scheme)
                var data = {}
                
                for(var i = 0; i < els.length; i++)
                    data[els[i].name] = $(els[i]).val()
                if(data.email == "" || data.subject == "" || data.content == "" || data.name == "")
                    return status.html("Please enter all the fields");
                var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
                if(!re.test(String(data.email).toLowerCase()))
                    return status.html("Email is not correct");
                
                $.ajax({
                    type: 'POST',
                    url: prefix + "/sendmail.lua",
                    contentType: 'application/json',
                    data: JSON.stringify(data),
                    dataType: 'json',
                    success: null
                }).done(function(r){
                    if(r.error)
                        alert(r.error)
                    else
                    {
                        obs.trigger("exit")
                        alert("Email sent. Thank")
                    }
                }).fail(function(){
                    alert("Service unavailable at the moment")
                })
            })
            $(scheme).css("visibility","visible")
        })
        riot.mount(scheme, {observable:obs})
    })
    .fail(function() {
        alert( "Cannot get the form" );
    })
}