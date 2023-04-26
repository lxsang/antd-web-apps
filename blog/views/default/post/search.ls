<div class="search-result">
<h2>Posts matched for query: <?=REQUEST.q?></h2>
<ul>
<?lua
    for i,v in ipairs(result) do
?>
    <li>
        <p class="title">
            <b>Score <?=string.format("%.3f",v[2])?></b> <a href="<?=HTTP_ROOT?>/post/id/<?=v[3].id?>"><?=v[3].title?></a>
        </p>
        <p class="preview">
            <?=v[3].content?>...
        </p>
    </li>
<?lua end ?>
</ul>
</div>