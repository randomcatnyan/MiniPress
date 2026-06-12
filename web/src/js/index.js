(() => {
  var __getOwnPropNames = Object.getOwnPropertyNames;
  var __commonJS = (cb, mod) => function __require() {
    return mod || (0, cb[__getOwnPropNames(cb)[0]])((mod = { exports: {} }).exports, mod), mod.exports;
  };
  var __async = (__this, __arguments, generator) => {
    return new Promise((resolve, reject) => {
      var fulfilled = (value) => {
        try {
          step(generator.next(value));
        } catch (e) {
          reject(e);
        }
      };
      var rejected = (value) => {
        try {
          step(generator.throw(value));
        } catch (e) {
          reject(e);
        }
      };
      var step = (x) => x.done ? resolve(x.value) : Promise.resolve(x.value).then(fulfilled, rejected);
      step((generator = generator.apply(__this, __arguments)).next());
    });
  };

  // ts/main.ts
  var require_main = __commonJS({
    "ts/main.ts"(exports) {
      (() => __async(exports, null, function* () {
        try {
          const c = yield fetch(".");
          console.log(c);
        } catch (err) {
          console.error("Erreur : " + err);
        }
      }))();
    }
  });
  require_main();
})();
//# sourceMappingURL=index.js.map
