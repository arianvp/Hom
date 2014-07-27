
'use strict';

var mercury = require('mercury');
// just re-exporting mercurcy for now. until we are gonna do more fancy stuff
module.exports = mercury;


// export to globals to we can access them with FFI. 
global.jsCreateElement = mercury.create;
global.jsNode = mercury.h;
global.jsDiff = mercury.diff;
global.jsPatch = function (patches, el) { mercury.patch(el,patches);};
global.jsText = String;
global.jsEmpty = function () {return [];};
global.jsCons = function (a,b) { return [a].concat(b); };
global.jsConcat = function (a,b) { return a.concat(b); };

global.jsRaf = requestAnimationFrame;

global.jsTestArrays = function (xs) { console.log(xs);};

global.test = function (a) { return a + 1; };

