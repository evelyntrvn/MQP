start "start" = term +
term "term" = body:(keyword / sentence) _ { return body; } // keyword to word

POINT = "." {return "point" }
DIGIT = [0-9]
INTDIGIT = [1-9]

primary "primary" = float/ int

float = first:int dec:dec { return parseFloat(`${first}`) + parseFloat(`${dec}`); } 
dec = point:POINT num:DIGIT+ { return parseFloat("." + `${num}`); }
int = first:INTDIGIT dig:DIGIT* { return parseInt(`${text()}`); }

regular = [^{}]+ { return text(); }
expr = regular* 

sentence = "{" expr:expr "}" { return expr.join("") } / regular

_ "whitespace" = [ \t\n\r]*

// conditional = cond:ifStatement / while / elseif  "(" condition ")" sentence { return cond; }
ifStatement = "if" expr "then" sentence "else" sentence /
   "if" expr "then" sentence  // conditional statement, what to return?

/****** Key Words ******/
keyword "keyword" = float/ diffuse / audio / time / circle / rect /
					triangle / polygon / ellipse / line / floor /
                    add / mult / subtract / divide / modulo / test /
                    colorA / colorB / rateA / rateB / feed / kill  / primary / $[^{} \t\n\r] +

diffuse  = "diffuse" { return "setDiffuse()";}

// Input and other
audio = "audio" { return "@audio";} //i want to be able to set audio on and off
time = "time" { return Date.getTime; }
test = "test" { return "@test" }

// Shapes and styles
circle = "circle" { return "@circle"; }
rect = "rect" _ x:primary _ y:primary _ w:primary _ h:primary { 
   var r = `shape.rect( ${x}, ${y}, ${w}, ${h} )`
   return r
   }

triangle = "triangle" { return "@triangle"; }
polygon = "polygon" { return "@polygon"; }
ellipse = "ellipse" { return "@ellipse"; }
line = "line" { return "@line"; }

bkgdColor = "bkgd" { return "@bkgd" }
hexChar = [0-9A-Fa-f] {return hexChar; }
hex = h:[0-9A-Fa-f]*{ return `${h.join("")}` } //is there anyways to specify a certain amount


// Math
floor = "floor" { return "@floor"; }
add = "+" { return "@+"; }
mult = "*" { return "@*"; }
subtract = "-" { return "@-"; }
divide = "/" { return "@/"; }
modulo = "%" { return "@%"; }

/****** Diffuse attributes ****/
colorA = "colorA(" h:hex ")"{ return `@colorA(${h})` ; } // change to be an equals sign
colorB = "colorB(" h:hex ")"{ return `@colorB(${h})` ; }
rateA = "rateA(" r:primary ")"{ return `setRateA(${r})` ; } //change to primary
rateB = "rateB(" r:primary ")"{ return `setRateB(${r})` ; } 
feed = "feed(" f:primary ")" { return `setFeed(${f})` ; } 
kill = "kill(" k:primary ")" { return `setKill(${k})` ; } 
