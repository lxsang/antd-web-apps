
$(document).ready(function () {
    const colors = [
        "#3957ff", "#d3fe14", "#c9080a", "#fec7f8", "#0b7b3e", "#0bf0e9", "#c203c8", "#fd9b39",
        "#888593", "#906407", "#98ba7f", "#fe6794", "#10b0ff", "#ac7bff", "#fee7c0", "#964c63",
        "#1da49c", "#0ad811", "#bbd9fd", "#fe6cfe", "#297192", "#d1a09c", "#78579e", "#81ffad",
        "#739400", "#ca6949", "#d9bf01", "#646a58", "#d5097e", "#bb73a9", "#ccf6e9", "#9cb4b6",
        "#b6a7d4", "#9e8c62", "#6e83c8", "#01af64", "#a71afd", "#cfe589", "#d4ccd1", "#fd4109",
        "#bf8f0e", "#2f786e", "#4ed1a5", "#d8bb7d", "#a54509", "#6a9276", "#a4777a", "#fc12c9",
        "#606f15", "#3cc4d9", "#f31c4e", "#73616f", "#f097c6", "#fc8772", "#92a6fe", "#875b44",
        "#699ab3", "#94bc19", "#7d5bf0", "#d24dfe", "#c85b74", "#68ff57", "#b62347", "#994b91",
        "#646b8c", "#977ab4", "#d694fd", "#c4d5b5", "#fdc4bd", "#1cae05", "#7bd972", "#e9700a",
        "#d08f5d", "#8bb9e1", "#fde945", "#a29d98", "#1682fb", "#9ad9e0", "#d6cafe", "#8d8328",
        "#b091a7", "#647579", "#1f8d11", "#e7eafd", "#b9660b", "#a4a644", "#fec24c", "#b1168c",
        "#188cc1", "#7ab297", "#4468ae", "#c949a6", "#d48295", "#eb6dc2", "#d5b0cb", "#ff9ffb",
        "#fdb082", "#af4d44", "#a759c4", "#a9e03a", "#0d906b", "#9ee3bd", "#5b8846", "#0d8995",
        "#f25c58", "#70ae4f", "#847f74", "#9094bb", "#ffe2f1", "#a67149", "#936c8e", "#d04907",
        "#c3b8a6", "#cef8c4", "#7a9293", "#fda2ab", "#2ef6c5", "#807242", "#cb94cc", "#b6bdd0",
        "#b5c75d", "#fde189", "#b7ff80", "#fa2d8e", "#839a5f", "#28c2b5", "#e5e9e1", "#bc79d8",
        "#7ed8fe", "#9f20c3", "#4f7a5b", "#f511fd", "#09c959", "#bcd0ce", "#8685fd", "#98fcff",
        "#afbff9", "#6d69b4", "#5f99fd", "#aaa87e", "#b59dfb", "#5d809d", "#d9a742", "#ac5c86",
        "#9468d5", "#a4a2b2", "#b1376e", "#d43f3d", "#05a9d1", "#c38375", "#24b58e", "#6eabaf"];
    
    d3.json("/post/graph_json")
        .then(
            function (json) {
                if (json.result) {
                    const tooltip_div = d3.select("#desktop")
                                            .append("div")
                                            .attr("class", "d3tooltip")
                                            .style("display", "none");
                    const links = json.result.links;
                    const nodes = json.result.nodes;


                    drag = simulation => {

                        function dragstarted(event) {
                            if (!event.active) simulation.alphaTarget(0.3).restart();
                            event.subject.fx = event.subject.x;
                            event.subject.fy = event.subject.y;
                            tooltip_div.style("display", "none");
                        }
                
                        function dragged(event) {
                            event.subject.fx = event.x;
                            event.subject.fy = event.y;
                        }
                
                        function dragended(event) {
                            if (!event.active) simulation.alphaTarget(0);
                            event.subject.fx = null;
                            event.subject.fy = null;
                        }
                
                        return d3.drag()
                            .on("start", dragstarted)
                            .on("drag", dragged)
                            .on("end", dragended);
                    };

                    const simulation = d3.forceSimulation(nodes)
                        .force("link",
                            d3.forceLink(links)
                                .id(d => d.id)
                                .distance(d => 1.0 / d.score)
                                .strength(d => d.score)
                        )
                        .force("charge", d3.forceManyBody())
                        .force("center", d3.forceCenter());
                    const svg = d3.create("svg")
                        .attr("preserveAspectRatio", "xMidYMid meet");
                    const link = svg.append("g")
                        .attr("stroke", "#999")
                        .attr("stroke-opacity", 0.8)
                        .selectAll("line")
                        .data(links)
                        .join("line")
                        .attr("stroke-width", d => d.score * 7.0); //d.score

                    const node = svg.append("g")
                        .attr("stroke", "#fff")
                        .attr("stroke-width", 0.5)
                        .selectAll("circle")
                        .data(nodes)
                        .join("circle")
                        .attr("r", (d) => {
                            conn = links.filter((l) => {
                                //console.log(d.id, l.target.id, l.source.id)
                                return l.target.id == d.id || l.source.id == d.id;
                            }).map(c=>c.score);
                            //return conn.reduce((a, b) => a + b, 0) * 10;
                            return conn.length;
                        })
                        .attr("fill", (d) => {
                            conn = links.filter((l) => {
                                //console.log(d.id, l.target.id, l.source.id)
                                return l.target.id == d.id || l.source.id == d.id;
                            });

                            return colors[conn.length % colors.length - 1];
                        })
                        .on("click", (d) => {
                            const index = $(d.target).index();
                            const data = nodes[index];
                            d3.json("/post/json/" + data.id)
                                .then( (json) => {
                                    if(json.result)
                                    {
                                        $("#floating_content").html(json.result.description);
                                        $("#floating_container").show();
                                        $("#floating_btn_read_more").attr("href", "/post/id/" + json.result.id);
                                    }
                                })
                                .catch ((e)=>{
                                    console.log(e);
                                });
                        })
                        .call(drag(simulation))
                        .on('mouseover', function (d) {
                            const index = $(d.target).index();
                            const data = nodes[index];
                            link.style('stroke', function (l) {
                                if (data.id == l.source.id || data.id == l.target.id)
                                    return "#9a031e";
                                else
                                    return "#999";
                            });
                            const off = $("#desktop").offset();
                            tooltip_div.transition()
                                .duration(200)
                                tooltip_div.style("display", "block")
                                .style("opacity", .8);
                            tooltip_div.html(data.title)
                                .style("left", (d.clientX - off.left + 10) + "px")
                                .style("top", (d.clientY - off.top + 10) + "px");
                        })
                        .on('mouseout', function () {
                            link.style('stroke', "#999");
                            tooltip_div.style("display", "none");
                        });

                    //node.append("title")
                    //    .text(d => d.title);

                    /*const label = svg.append("g")
                        .attr("stroke", "#fff")
                        .attr("stroke-width", 0.2)
                        .selectAll("text")
                        .data(nodes)
                        .join("text")
                        .text(d=>d.id)
                        .style("user-select", "none")
                        .style("font-size", (d) =>{
                            conn = links.filter((l) => {
                                //console.log(d.id, l.target.id, l.source.id)
                                return l.target.id == d.id || l.source.id == d.id;
                            });
                            return conn.length + "px";
                        })
                        .style('fill', '#000');*/


                    simulation.on("tick", () => {
                        link
                            .attr("x1", d => d.source.x)
                            .attr("y1", d => d.source.y)
                            .attr("x2", d => d.target.x)
                            .attr("y2", d => d.target.y);

                        node
                            .attr("cx", d => d.x)
                            .attr("cy", d => d.y);

                        const nodes_x = nodes.map(d => d.x);
                        const nodes_y = nodes.map(d => d.y);
                        const min_x = Math.min(...nodes_x) - 10;
                        const min_y = Math.min(...nodes_y) - 10;
                        const w = Math.max(...nodes_x) - min_x + 10;
                        const h = Math.max(...nodes_y) - min_y + 10;
                        svg.attr("viewBox",
                            [min_x, min_y, w, h]);
                        /*label
                            .attr("x", d => {
                                conn = links.filter((l) => {
                                    //console.log(d.id, l.target.id, l.source.id)
                                    return l.target.id == d.id || l.source.id == d.id;
                                });
                                return d.x - conn.length / 2;
                            })
                            .attr("y", d => {
                                conn = links.filter((l) => {
                                    //console.log(d.id, l.target.id, l.source.id)
                                    return l.target.id == d.id || l.source.id == d.id;
                                });
                                return d.y + conn.length / 2;
                            });*/
                    });

                    // invalidation.then(() => simulation.stop());
                    $("#floating_btn_close").click((e)=>{
                        $("#floating_container").hide();
                    });
                    $("#desktop")
                        .css("position", "relative");
                    $("#container")
                        .css("height", "100%")
                        .css("position", "relative")
                        .append($(svg.node())
                            .css("height", "calc(100% - 10px)")
                            .css("margin", "0 auto")
                            .css("display", "block"));
                }
            }
        )
        .catch((e) => {
            console.log(e);
        });
});