<?lua
    if HEADER.mobile then return end
    if not data then return end
?>
<div class = "cv-toc">
<ul>
<?lua
    local active = "toc_active"
    for k, v in pairs(data) do
?>
    <li class="<?=active?>"><a href=<?='"#toc'..v[2]..'"'?> onclick='switchTab("toc<?=v[2]?>", this)' ><?=v[1]?></a></li>
<?lua
    active = ''
    end
?>
</ul>
</div>