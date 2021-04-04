<div class="header_container">
        <?lua if data.photo and data.photo ~= "" then ?>
            <img src="/<?=data.user?>/user/photo"></img>
        <?lua end ?>
        <h1>
            <span class="name"><?=data.fullname?></span>
            <span class="cv">Curriculum Vitae</span>
        </h1>
        <p class="coordination">
            <span class="fa fa-home"></span><?=data.address?></p>
        <p class="coordination">
            <span class="fa fa-phone"></span>
            <span class="text"><?=data.Phone?></span>
            <span class="fa fa-envelope-o"></span>
            <span class="text"><?=data.email?></span>
            <br/>
            <span class="fa fa-globe"></span>
            <span class="text"><a href ="<?=data.url?>"><?=data.url?></a></span>
            <?lua
            if not preview then
            ?>
                <span class="fa fa-file-pdf-o"></span>
                <span class="text"><a href ="<?=HTTP_ROOT?>/<?=data.user?>/index/pdf" target="_blank">Download</a></span>
            <?lua
            end
            ?>
        </p>
        <p class="shortbio">
            <span class="fa fa-quote-left"></span>
            <span><?=data.shortbiblio?></span>
            <span class="fa fa-quote-right"></span>
        </p>
</div>
<?lua if not HEADER.mobile and data.user == "mrsang" then ?>
<iframe width="770" height="330" src="https://mars.nasa.gov/layout/embed/send-your-name/future/certificate/?cn=792789419260" frameborder="0"></iframe>
<?lua end ?>