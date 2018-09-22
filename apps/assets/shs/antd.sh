#! /bin/bash
echo "AND auto build script"
if [ -d "ant-http" ]; then
    echo "Updating Antd source..."
    cd "ant-http"
    git stash
    git pull
else
    echo "Getting Antd..."
    git clone https://github.com/lxsang/ant-http
    cd "ant-http"
fi
[[ -d "plugins" ]] || mkdir "plugins"
echo "getting plugins..."
cd "plugins"

for plugin in $1; do
    echo "Getting plugin: $plugin..."
    if [ -d "antd-$plugin-plugin" ]; then
        echo "Updating $plugin source..."
        cd "antd-$plugin-plugin"
        git pull
        cd ../
    else
        echo "Getting $plugin..."
        git clone "https://github.com/lxsang/antd-$plugin-plugin"
    fi
done
cd ../
# ask user for some custom setting
read -p "Build to (absolute path):" build_dir </dev/tty
[[ -d "$build_dir" ]] || mkdir -p "$build_dir"
[[ -d "$build_dir/htdocs" ]] || mkdir -p "$build_dir/htdocs"
[[ -d "$build_dir/database" ]] || mkdir -p "$build_dir/database"
[[ -d "$build_dir/tmp" ]] || mkdir -p "$build_dir/tmp"
escape="${build_dir//\//\\/}"
escape="${escape//\./\\.}"
read -p "Default HTTP port : " http_port </dev/tty
cmd="sed -i -E 's/[^P]BUILDIRD=.*/BUILDIRD=$escape/' var.mk"
eval $cmd
echo 
make && make antd_plugins
if [ $? -eq 0 ]; then
    echo "[SERVER]" > "$build_dir/config.ini"
    echo "port=$http_port" >> "$build_dir/config.ini"
    echo "plugins=$build_dir/plugins" >> "$build_dir/config.ini"
    echo "plugins_ext=.dylib" >> "$build_dir/config.ini"
    echo "database=$build_dir/database" >> "$build_dir/config.ini"
    echo "htdocs=$build_dir/htdocs" >> "$build_dir/config.ini"
    echo "tmpdir=$build_dir/tmp" >> "$build_dir/config.ini"
    echo "ssl.enable=0" >> "$build_dir/config.ini"
    chmod u+x "$build_dir/antd"
    echo "Build done, to run the server, execute the command:"
    echo "$build_dir/antd"
else
    echo "FAIL to build, please check dependencies"
fi
