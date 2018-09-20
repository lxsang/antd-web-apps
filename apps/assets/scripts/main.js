// Generated by CoffeeScript 1.9.3
(function() {
  var APIManager, BaseObject, MarkOn, WVNC, require,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  window.classes = {};

  window.libraries = {};

  window.myuri = "/";

  window.mobilecheck = function() {
    if (navigator.userAgent.match(/Android/i) || navigator.userAgent.match(/webOS/i) || navigator.userAgent.match(/iPhone/i) || navigator.userAgent.match(/iPad/i) || navigator.userAgent.match(/iPod/i) || navigator.userAgent.match(/BlackBerry/i) || navigator.userAgent.match(/Windows Phone/i)) {
      return true;
    }
    return false;
  };

  window.makeclass = function(n, o) {
    return window.classes[n] = o;
  };


  /* 
  window.require = (lib) ->
      return new Promise (r, e) ->
          return r() if window.libraries[lib]
          $.getScript window.myuri + lib
              .done (d) ->
                  window.libraries[lib] = true
                  r()
              .fail (m, s) ->
                  e(m, s)
   */

  require = function(lib) {
    return new Promise(function(r, e) {
      if (window.libraries[lib]) {
        return r();
      }
      return $.getScript(window.myuri + lib).done(function(d) {
        window.libraries[lib] = true;
        return r();
      }).fail(function(m, s) {
        return e(m, s);
      });
    });
  };

  BaseObject = (function() {
    function BaseObject(name) {
      this.name = name;
    }

    BaseObject.prototype.ready = function() {
      var me;
      me = this;
      return new Promise(function(r, e) {
        return me.resolveDep().then(function() {
          return r();
        })["catch"](function(m, s) {
          return e(m, s);
        });
      });
    };

    BaseObject.prototype.resolveDep = function() {
      var me;
      me = this;
      return new Promise(function(r, e) {
        var dep, fn;
        dep = window.classes[me.name].dependencies;
        if (!dep) {
          r();
        }
        fn = function(l, i) {
          if (i >= dep.length) {
            return r();
          }
          return require(l[i]).then(function() {
            return fn(l, i + 1);
          })["catch"](function(m, s) {
            return e(m, s);
          });
        };
        return fn(dep, 0);
      });
    };

    return BaseObject;

  })();

  makeclass("BaseObject", BaseObject);

  APIManager = (function(superClass) {
    extend(APIManager, superClass);

    function APIManager(args) {
      this.args = args;
      APIManager.__super__.constructor.call(this, "APIManager");
    }

    APIManager.prototype.init = function() {
      var cname, me;
      me = this;
      if (!(this.args && this.args.length > 0)) {
        return console.error("No class found");
      }
      cname = (this.args.splice(0, 1))[0].trim();
      return this.ready().then(function() {
        if (mobilecheck()) {
          mobileConsole.init();
        }
        if (!cname || cname === "") {
          return;
        }
        if (!window.classes[cname]) {
          return console.error("Cannot find class ", cname);
        }
        return (new window.classes[cname](me.args)).init();
      })["catch"](function(m, s) {
        return console.error(m, s);
      });
    };

    return APIManager;

  })(window.classes.BaseObject);

  APIManager.dependencies = ["/assets/scripts/mobile_console.js"];

  makeclass("APIManager", APIManager);

  MarkOn = (function(superClass) {
    extend(MarkOn, superClass);

    function MarkOn() {
      MarkOn.__super__.constructor.call(this, "MarkOn");
    }

    MarkOn.prototype.init = function() {
      var me;
      me = this;
      return this.ready().then(function() {
        return me.editor = new SimpleMDE({
          element: $("#editor")[0]
        });
      })["catch"](function(m, s) {
        return console.error(m, s);
      });
    };

    return MarkOn;

  })(window.classes.BaseObject);

  MarkOn.dependencies = ["/rst/gscripts/mde/simplemde.min.js"];

  makeclass("MarkOn", MarkOn);

  WVNC = (function(superClass) {
    extend(WVNC, superClass);

    function WVNC(args) {
      var me;
      this.args = args;
      WVNC.__super__.constructor.call(this, "WVNC");
      this.socket = void 0;
      this.uri = void 0;
      if (this.args && this.args.length > 0) {
        this.uri = this.args[0];
      }
      this.canvas = void 0;
      if (this.args && this.args.length > 1) {
        this.canvas = ($(this.args[1]))[0];
      }
      this.buffer = $("<canvas>")[0];
      this.lastPose = {
        x: 0,
        y: 0
      };
      this.scale = 0.8;
      this.decoder = new Worker('/assets/scripts/decoder.js');
      me = this;
      this.mouseMask = 0;
      this.decoder.onmessage = function(e) {
        return me.process(e.data);
      };
    }

    WVNC.prototype.init = function() {
      var me;
      me = this;
      return this.ready().then(function() {
        $("#stop").click(function(e) {
          if (me.socket) {
            return me.socket.close();
          }
        });
        $("#connect").click(function(e) {
          return me.openSession();
        });
        return me.initInputEvent();
      })["catch"](function(m, s) {
        return console.error(m, s);
      });
    };

    WVNC.prototype.initInputEvent = function() {
      var getMousePos, hamster, me, sendMouseLocation;
      me = this;
      getMousePos = function(e) {
        var pos, rect;
        rect = me.canvas.getBoundingClientRect();
        pos = {
          x: Math.floor((e.clientX - rect.left) / me.scale),
          y: Math.floor((e.clientY - rect.top) / me.scale)
        };
        return pos;
      };
      sendMouseLocation = function(e) {
        var p;
        p = getMousePos(e);
        return me.sendPointEvent(p.x, p.y, me.mouseMask);
      };
      if (!me.canvas) {
        return;
      }
      ($(me.canvas)).css("cursor", "none");
      ($(me.canvas)).contextmenu(function(e) {
        e.preventDefault();
        return false;
      });
      ($(me.canvas)).mousemove(function(e) {
        return sendMouseLocation(e);
      });
      ($(me.canvas)).mousedown(function(e) {
        var state;
        state = 1 << e.button;
        me.mouseMask = me.mouseMask | state;
        return sendMouseLocation(e);
      });
      ($(me.canvas)).mouseup(function(e) {
        var state;
        state = 1 << e.button;
        me.mouseMask = me.mouseMask & (~state);
        return sendMouseLocation(e);
      });
      me.canvas.onkeydown = me.canvas.onkeyup = me.canvas.onkeypress = function(e) {
        var code;
        if (e.key === "Shift") {
          code = 16;
        } else if (e.ctrlKey) {
          code = 17;
        } else if (e.altKey) {
          code = 18;
        } else if (e.metaKey) {
          code = 91;
        } else {
          code = String.charCodeAt(e.key);
        }
        if (e.type === "keydown") {
          me.sendKeyEvent(code, 1);
        } else if (e.type === "keyup") {
          me.sendKeyEvent(code, 0);
        }
        return e.preventDefault();
      };
      hamster = Hamster(this.canvas);
      return hamster.wheel(function(event, delta, deltaX, deltaY) {
        var p;
        p = getMousePos(event.originalEvent);
        if (delta > 0) {
          me.sendPointEvent(p.x, p.y, 8);
          me.sendPointEvent(p.x, p.y, 0);
          return;
        }
        me.sendPointEvent(p.x, p.y, 16);
        return me.sendPointEvent(p.x, p.y, 0);
      });
    };

    WVNC.prototype.initCanvas = function(w, h, d) {
      var ctx, data, me;
      me = this;
      this.depth = d;
      this.buffer.width = w;
      this.buffer.height = h;
      this.resolution = {
        w: w,
        h: h,
        depth: this.depth
      };
      this.decoder.postMessage(this.resolution);
      ctx = this.buffer.getContext('2d');
      data = ctx.createImageData(w, h);
      return ctx.putImageData(data, 0, 0);
    };

    WVNC.prototype.process = function(data) {
      var ctx, imgData;
      data.pixels = new Uint8ClampedArray(data.pixels);
      if (data.flag === 0 && this.resolution.depth === 32) {
        data.pixels = data.pixels.subarray(10);
      }
      ctx = this.buffer.getContext('2d');
      imgData = ctx.createImageData(data.w, data.h);
      imgData.data.set(data.pixels);
      ctx.putImageData(imgData, data.x, data.y);
      if (data.x !== this.lastPose.x || data.y > this.resolution.h - 10) {
        this.draw();
      }
      return this.lastPose = {
        x: data.x,
        y: data.y
      };
    };

    WVNC.prototype.setScale = function(n) {
      this.scale = n;
      return this.draw();
    };

    WVNC.prototype.draw = function() {
      var ctx, h, w;
      if (!this.socket) {
        return;
      }
      w = this.buffer.width * this.scale;
      h = this.buffer.height * this.scale;
      this.canvas.width = w;
      this.canvas.height = h;
      ctx = this.canvas.getContext("2d");
      ctx.save();
      ctx.scale(this.scale, this.scale);
      ctx.clearRect(0, 0, w, h);
      ctx.drawImage(this.buffer, 0, 0);
      return ctx.restore();
    };

    WVNC.prototype.openSession = function() {
      var me;
      me = this;
      if (this.socket) {
        this.socket.close();
      }
      if (!this.uri) {
        return;
      }
      this.socket = new WebSocket(this.uri);
      this.socket.binaryType = "arraybuffer";
      this.socket.onopen = function() {
        console.log("socket opened");
        return me.initConnection();
      };
      this.socket.onmessage = function(e) {
        return me.consume(e);
      };
      return this.socket.onclose = function() {
        me.socket = null;
        return console.log("socket closed");
      };
    };

    WVNC.prototype.initConnection = function() {
      var data, rate, vncserver;
      vncserver = "localhost:5901";
      data = new Uint8Array(vncserver.length + 5);
      data[0] = 16;

      /*
      flag:
          0: raw data no compress
          1: jpeg no compress
          2: raw data compressed by zlib
          3: jpeg data compressed by zlib
       */
      data[1] = 2;
      data[2] = 50;
      rate = 30;
      data[3] = rate & 0xFF;
      data[4] = (rate >> 8) & 0xFF;
      data.set((new TextEncoder()).encode(vncserver), 5);
      return this.socket.send(this.buildCommand(0x01, data));
    };

    WVNC.prototype.sendPointEvent = function(x, y, mask) {
      var data;
      if (!this.socket) {
        return;
      }
      data = new Uint8Array(5);
      data[0] = x & 0xFF;
      data[1] = x >> 8;
      data[2] = y & 0xFF;
      data[3] = y >> 8;
      data[4] = mask;
      return this.socket.send(this.buildCommand(0x05, data));
    };

    WVNC.prototype.sendKeyEvent = function(code, v) {
      var data;
      if (!this.socket) {
        return;
      }
      data = new Uint8Array(2);
      data[0] = code;
      data[1] = v;
      console.log(String.fromCharCode(code), v);
      return this.socket.send(this.buildCommand(0x06, data));
    };

    WVNC.prototype.buildCommand = function(hex, o) {
      var cmd, data;
      data = void 0;
      switch (typeof o) {
        case 'string':
          data = (new TextEncoder()).encode(o);
          break;
        case 'number':
          data = new Uint8Array([o]);
          break;
        default:
          data = o;
      }
      cmd = new Uint8Array(data.length + 3);
      cmd[0] = hex;
      cmd[2] = data.length >> 8;
      cmd[1] = data.length & 0x0F;
      cmd.set(data, 3);
      return cmd.buffer;
    };

    WVNC.prototype.consume = function(e) {
      var arr, cmd, data, dec, depth, h, pass, user, w;
      data = new Uint8Array(e.data);
      cmd = data[0];
      switch (cmd) {
        case 0xFE:
          data = data.subarray(1, data.length - 1);
          dec = new TextDecoder("utf-8");
          return console.log("Error", dec.decode(data));
        case 0x81:
          console.log("Request for password");
          pass = "!x$@n9";
          return this.socket.send(this.buildCommand(0x02, pass));
        case 0x82:
          console.log("Request for login");
          user = "mrsang";
          pass = "!x$@n9";
          arr = new Uint8Array(user.length + pass.length + 1);
          arr.set((new TextEncoder()).encode(user), 0);
          arr.set(['\0'], user.length);
          arr.set((new TextEncoder()).encode(pass), user.length + 1);
          return this.socket.send(this.buildCommand(0x03, arr));
        case 0x83:
          console.log("resize");
          w = data[1] | (data[2] << 8);
          h = data[3] | (data[4] << 8);
          depth = data[5];
          this.initCanvas(w, h, depth);
          return this.socket.send(this.buildCommand(0x04, 1));
        case 0x84:
          return this.decoder.postMessage(data.buffer, [data.buffer]);
        default:
          return console.log(cmd);
      }
    };

    return WVNC;

  })(window.classes.BaseObject);

  WVNC.dependencies = ["/assets/scripts/hamster.js"];

  makeclass("WVNC", WVNC);

}).call(this);
