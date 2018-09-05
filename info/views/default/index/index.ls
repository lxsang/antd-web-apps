<?lua
    if not data then return end

    for k,v in pairs(data) do
        if v.children then
?>
        <div class="container" id =<?='"toc'..v.id..'"'?>>
            <h1><?=v.name:gsub("^%d+%.","")?></h1>
        <?lua
            for l,child in pairs(v.children) do
        ?>
            <div class="sub-container">
                <h2><?=child.name:gsub("^%d+%.","")?></h2>
                <?lua
                    if child.sections then
                        for m, entry in pairs(child.sections) do
                ?>
                <div class= "entry">
                    <p>
                        <?lua if entry.title ~= "" then ?>
                            <span class= "fa  fa-bookmark"></span>
                            <span class= "title"><?=entry.title?></span>
                        <?lua end ?>
                        <span class= "title-optional"></span>
                        <span class="location"><?=entry.location?></span>
                    </p>
                    <div class="entry-short-des">
                        <span><?=entry.subtitle?></span>
                        <span class="date">
                        <?lua
                            if entry["start"]:match("^20%d.*") and entry['end']:match("^20%d.*")  then
                                echo(entry.start.."-"..entry['end'])
                            end
                        ?>
                        </span>
                    </div>
                    <div class="entry-description">
                            <?=entry.content?>
                    </div>
                </div>
                <?lua
                        end
                    end
                ?>
            </div>
        <?lua
            end
        ?>
        </div>
<?lua 
        else
?>
            <div class="container" id =<?='"toc'..v.id..'"'?>>
                <h1><?=v.name?></h1>
            <?lua
            if v.sections then
                for m, entry in pairs(v.sections) do
            ?>
                    <div class= "entry">
                        <p>
                            <?lua if entry.title ~= "" then ?>
                                <span class= "fa  fa-bookmark"></span>
                                <span class= "title"><?=entry.title?></span>
                            <?lua end ?>
                            <span class= "title-optional"></span>
                            <span class="location"><?=entry.location?></span>
                        </p>
                        <div class="entry-short-des">
                            <span><?=entry.subtitle?></span>
                            <span class="date">
                            <?lua
                                if entry["start"]:match("^20%d.*") and entry['end']:match("^20%d.*") then
                                    echo(entry.start.."-"..entry['end'])
                                end
                            ?>
                            </span>
                        </div>
                        <div class="entry-description">
                                <?=entry.content?>
                        </div>
                    </div>
            <?lua
                end
            end 
            ?>
            </div>
<?lua
        end
    end
?>