<?lua
    local args = {...}
    local data = args[1].data
?>

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
    <span class="fa fa-globe"></span>
    <span class="text"><a href ="<?=data.url?>"><?=data.url?></a></span>
</p>
<p class="shortbio">
    <span class="fa fa-quote-left"></span>
    <span><?=data.shortbiblio?></span>
    <span class="fa fa-quote-right"></span>
</p>