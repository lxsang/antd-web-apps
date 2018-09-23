<div id="screen_container">
<ul id = "tool_bar">
    <li class ="title">VNC client demo</li>
    <li><a id="connect" href="#">Connect</a></li>
    <li><a id="stop" href="#">Disconnect</a></li>
    <li>
        Scale (percent):
        <select id="selscale">
            <option value="50">40</option>
            <option value="60">60</option>
            <option value="80">80</option>
            <option value="100" selected="selected">100</option>
        </select>
    </li>
    <li id ="tbstatus"></li>
</ul>
<div style="width:1px; display:block; clear:both;"></div>
<canvas id = "canvas" tabindex="1"></canvas>