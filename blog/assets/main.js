var scheme = undefined;
OS.GUI.workspace = undefined;
String.prototype.__ = function () {
    return this;
};
function subscribe(prefix) {
    if (!OS.GUI.workspace) OS.GUI.workspace = $("body");
    if (scheme) return;
    // get scheme
    $.get(prefix + "/rst/subscribe.html")
        .done(function (d) {
            scheme = $.parseHTML(d);
            var obs = new OS.API.Announcer();
            $(scheme).css("visibility", "hidden");
            $("body").append(scheme);
            obs.on("exit", function () {
                $(scheme).remove();
                scheme = undefined;
            });
            obs.on("rendered", function (d) {
                console.log("rednered");
                $(".afx-window-title", scheme).html("Subscribe");
                $("[data-id='send']", scheme).click(function () {
                    var status = $("[data-id='status']", scheme);
                    status.html("");
                    var els = $("[data-class='data']", scheme);
                    var data = {};

                    for (var i = 0; i < els.length; i++)
                        data[els[i].name] = $(els[i]).val();
                    if (
                        data.email == "" ||
                        data.subject == "" ||
                        data.content == "" ||
                        data.name == ""
                    )
                        return status.html("Please enter all the fields");
                    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
                    if (!re.test(String(data.email).toLowerCase()))
                        return status.html("Email is not correct");

                    $.ajax({
                        type: "POST",
                        url: prefix + "/service/subscribe",
                        contentType: "application/json",
                        data: JSON.stringify(data),
                        dataType: "json",
                        success: null,
                    })
                        .done(function (r) {
                            if (r.error) {
                                console.log(r.error);
                                alert(r.error);
                            } else {
                                obs.trigger("exit");
                                alert("You have been subscribed. Thanks");
                            }
                        })
                        .fail(function (e, s) {
                            console.log(e);
                            alert("Error: " + e);
                        });
                });
                $(scheme).css("visibility", "visible");
            });
            scheme[0].uify(obs, true);
        })
        .fail(function () {
            alert("Cannot get the form");
        });
}
function mailtoMe(prefix) {
    if (!OS.GUI.workspace) OS.GUI.workspace = $("body");
    if (scheme) return;
    // get scheme
    $.get(prefix + "/rst/sendto.html")
        .done(function (d) {
            scheme = $.parseHTML(d);
            var obs = new OS.API.Announcer();
            $(scheme).css("visibility", "hidden");
            $("body").append(scheme);
            obs.on("exit", function () {
                $(scheme).remove();
                scheme = undefined;
            });
            obs.on("rendered", function (d) {
                $(".afx-window-title", scheme).html("Send me an email");
                $("[data-id='send']", scheme).click(function () {
                    var status = $("[data-id='status']", scheme);
                    status.html("");
                    var els = $("[data-class='data']", scheme);
                    var data = {};

                    for (var i = 0; i < els.length; i++)
                        data[els[i].name] = $(els[i]).val();
                    if (
                        data.email == "" ||
                        data.subject == "" ||
                        data.content == "" ||
                        data.name == ""
                    )
                        return status.html("Please enter all the fields");
                    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
                    if (!re.test(String(data.email).toLowerCase()))
                        return status.html("Email is not correct");

                    $.ajax({
                        type: "POST",
                        url: prefix + "/service/sendmail",
                        contentType: "application/json",
                        data: JSON.stringify(data),
                        dataType: "json",
                        success: null,
                    })
                        .done(function (r) {
                            if (r.error) {
                                console.log(r.error);
                                alert(r.error);
                            } else {
                                obs.trigger("exit");
                                alert("Email sent. Thank");
                            }
                        })
                        .fail(function () {
                            alert("Service unavailable at the moment");
                        });
                });
                $(scheme).css("visibility", "visible");
            });
            scheme[0].uify(obs, true);
        })
        .fail(function () {
            alert("Cannot get the form");
        });
}
