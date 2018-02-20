<?lua 
    local die = function(m)
        echo(m)
        debug.traceback=nil
        error("Permission denied")
    end
    std.html()
    local user = "mrsang"
    local db = require("db.model").get("mrsang","user",nil)
    if db == nil then die("cannot get db data") end
    local data = db:getAll()
    db:close()
    if data == nil or data[0] == nil then die("Cannot fetch user info") end
    data = data[0]
?>
<html>
    <head>
        <!--script type="text/javascript" src="../os/scripts/jquery-3.2.1.min.js"></script-->
        <script type="text/javascript" src="main.js"></script>
        <link rel="stylesheet" type="text/css" href="style.css" />
        <link rel="stylesheet" type="text/css" href="font-awesome.css" />
    </head>
    <body>
        <div class="layout">
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
                <span class="text"><?=data.url?></span>
            </p>
            <p class="shortbio">
                <span class="fa fa-quote-left"></span>
                <span><?=data.shortbiblio?></span>
                <span class="fa fa-quote-right"></span>
            </p>
            <div class="container">
                <h1>Education</h1>
                <div class="sub-container">
                    <h2>Academic Qualifications</h2>

                    <div class= "entry">
                        <p>
                            <span class= "fa  fa-bookmark"></span>
                            <span class= "title">Universite de Bretagne Occidental</span>
                            <span class= "title-optional"></span>
                            <span class="location">Brest, France</span>
                        </p>
                        <div class="entry-short-des">
                            <span>PhD in computer science</span>
                            <span class="date">2014-2017</span>
                        </div>
                        <div class="entry-description">
                        </div>
                    </div>

                    <div class= "entry">
                        <p>
                            <span class= "fa  fa-bookmark"></span>
                            <span class= "title">Universite de Bretagne Occidental</span>
                            <span class= "title-optional"></span>
                            <span class="location">Brest, France</span>
                        </p>
                        <div class="entry-short-des">
                            <span>PhD in computer science</span>
                            <span class="date">2014-2017</span>
                        </div>
                        <div class="entry-description">
                        </div>
                    </div>

                    <div class= "entry">
                        <p>
                            <span class= "fa  fa-bookmark"></span>
                            <span class= "title">Universite de Bretagne Occidental</span>
                            <span class= "title-optional"></span>
                            <span class="location">Brest, France</span>
                        </p>
                        <div class="entry-short-des">
                            <span>PhD in computer science</span>
                            <span class="date">2014-2017</span>
                        </div>
                        <div class="entry-description">
                        </div>
                    </div>

                </div>

                <div class="sub-container">
                    <h2>Notable Projects</h2>

                    <div class= "entry">
                        <p>
                            <span class= "fa  fa-bookmark"></span>
                            <span class= "title">PHD Project (Ongoing)</span>
                            <span class= "title-optional">
                                Software/FPGA Co-design for Edge-computing: Promoting Object-oriented Design
                            </span>
                            <span class="location"></span>
                        </p>
                        <div class="entry-short-des">
                            <span></span>
                            <span class="date">At: Mines-Télécom, Mines Douai and ENSTA Bretagne, France</span>
                        </div>
                        <div class="entry-description">
                            Working as a PhD student, my research focuses on the application of the object-oriented design methodol- ogy in embedded systems. The work mainly focuses on: (1) the use of object-oriented design principles on hardware design, especially on FPGA design. (2) The implementation of an object oriented and distributed platform for edge-computing on hybrid (SW/HW) sensor network, based on a Virtual Machine (Smalltalk) solution. The goal facilitates the development, deployment and maintenance of distributed applications on that hybrid and reconfigurable system. This project is a collaboration between ENSTA Bretagne and École des Mines de Douai.
                        </div>
                    </div>

                    <div class= "entry">
                        <p>
                            <span class= "fa  fa-bookmark"></span>
                            <span class= "title">Master 2 project (Internship)</span>
                            <span class= "title-optional">
                                Optimization by parallelization of the 3d elastic free form deformation algorithm
                            </span>
                            <span class="location"></span>
                        </p>
                        <div class="entry-short-des">
                            <span></span>
                            <span class="date">At: Mines-Télécom, Mines Douai and ENSTA Bretagne, France</span>
                        </div>
                        <div class="entry-description">
                            Working as a PhD student, my research focuses on the application of the object-oriented design methodol- ogy in embedded systems. The work mainly focuses on: (1) the use of object-oriented design principles on hardware design, especially on FPGA design. (2) The implementation of an object oriented and distributed platform for edge-computing on hybrid (SW/HW) sensor network, based on a Virtual Machine (Smalltalk) solution. The goal facilitates the development, deployment and maintenance of distributed applications on that hybrid and reconfigurable system. This project is a collaboration between ENSTA Bretagne and École des Mines de Douai.
                        </div>
                    </div>


                </div>


            </div>


            <div class="container">
                <h1>Previous employment</h1>

                <div class= "entry">
                    <p>
                        <span class= "fa  fa-bookmark"></span>
                        <span class= "title">ENSTA Bretagne</span>
                        <span class= "title-optional"></span>
                        <span class="location">Brest, France</span>
                    </p>
                    <div class="entry-short-des">
                        <span>3 years CDD</span>
                        <span class="date">2014-2017</span>
                    </div>
                    <div class="entry-description">
                        Working as researcher, partition in the research of the application of object-oriented design methodology in embedded systems.
                    </div>
                </div>

                <div class= "entry">
                    <p>
                        <span class= "fa  fa-bookmark"></span>
                        <span class= "title">ENSTA Bretagne</span>
                        <span class= "title-optional"></span>
                        <span class="location">Brest, France</span>
                    </p>
                    <div class="entry-short-des">
                        <span>3 years CDD</span>
                        <span class="date">2014-2017</span>
                    </div>
                    <div class="entry-description">
                        Working as researcher, partition in the research of the application of object-oriented design methodology in embedded systems.
                    </div>
                </div>

                <div class= "entry">
                    <p>
                        <span class= "fa  fa-bookmark"></span>
                        <span class= "title">ENSTA Bretagne</span>
                        <span class= "title-optional"></span>
                        <span class="location">Brest, France</span>
                    </p>
                    <div class="entry-short-des">
                        <span>3 years CDD</span>
                        <span class="date">2014-2017</span>
                    </div>
                    <div class="entry-description">
                        Working as researcher, partition in the research of the application of object-oriented design methodology in embedded systems.
                    </div>
                </div>


            </div>

             <div class="container">
                <h1>Technical and Personal skills</h1>
                <div class= "entry">
                    <p>
                        <span class= "fa  fa-bookmark"></span>
                        <span class= "title">Programming language</span>
                        <span class= "title-optional"></span>
                        <span class="location"></span>
                    </p>
                    <div class="entry-short-des">
                        <span></span>
                        <span class="date"></span>
                    </div>
                    <div class="entry-description">
                        Proficient in: C, C++, Pharo (Smalltalk), Python, Ruby, Java, PHP, Lua, Shell script, VHDL, HTML, Javascript, CSS. Also basic ability with: Assembly, Matlab.
                    </div>
                </div>

                <div class= "entry">
                    <p>
                        <span class= "fa  fa-bookmark"></span>
                        <span class= "title">Programming language</span>
                        <span class= "title-optional"></span>
                        <span class="location"></span>
                    </p>
                    <div class="entry-short-des">
                        <span></span>
                        <span class="date"></span>
                    </div>
                    <div class="entry-description">
                        Proficient in: C, C++, Pharo (Smalltalk), Python, Ruby, Java, PHP, Lua, Shell script, VHDL, HTML, Javascript, CSS. Also basic ability with: Assembly, Matlab.
                    </div>
                </div>

                <div class= "entry">
                    <p>
                        <span class= "fa  fa-bookmark"></span>
                        <span class= "title">Programming language</span>
                        <span class= "title-optional"></span>
                        <span class="location"></span>
                    </p>
                    <div class="entry-short-des">
                        <span></span>
                        <span class="date"></span>
                    </div>
                    <div class="entry-description">
                        Proficient in: C, C++, Pharo (Smalltalk), Python, Ruby, Java, PHP, Lua, Shell script, VHDL, HTML, Javascript, CSS. Also basic ability with: Assembly, Matlab.
                    </div>
                </div>

            </div>

        </div>
    </body>
</html>