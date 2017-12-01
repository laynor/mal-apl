#! apl --script
⍝ r∆tokenize '(+ 1 2 "foo bar" antani :posterdati) ~antani'
⍝ ┌→──────────────────────────────────────────────────────────────────┐
⍝ │┌→┐ ┌→┐ ┌→┐ ┌→┐ ┌→────────┐ ┌→─────┐ ┌→──────────┐ ┌→┐ ┌→┐ ┌→─────┐│
⍝ ││(│ │+│ │1│ │2│ │"foo bar"│ │antani│ │:posterdati│ │)│ │~│ │antani││
⍝ │└─┘ └─┘ └─┘ └─┘ └─────────┘ └──────┘ └───────────┘ └─┘ └─┘ └──────┘│
⍝ └∊──────────────────────────────────────────────────────────────────┘

∇R←r∆tokenize S;TOK;STR;i;append∆token
  append∆token←{⍺,(⍬≢⍵)/⊂⍵}
  i←0
  TOK←R←⍬
start:
  i←i+1
  →(i > ⍴S)/appendTokenAndExit
  →(S[i]∊"'`&@~[](){}")/appendTokenAndChar
  →(S[i]∊'"')/string
  →(S[i]∊' ')/whitespace
  TOK←TOK,S[i]
  →start
whitespace:
  R←R append∆token TOK
  TOK←⍬
  →start
appendTokenAndChar:
  R←R append∆token TOK
  TOK←⍬
  R←R append∆token (∊S[i])
  →start
string:
  STR←'"'
stringContent:
  i←i+1
  →(S[i] = '\')/readEscape
  →(S[i] = '"')/endString
  STR←STR,S[i]
  →stringContent
readEscape:
  ⍝ String unescaping is done here rather than in the read function
  i←i+1
  STR←STR,1↑(S[i] = 'rntba"\')/(⎕ucs 13 10 9 8 7 34 92)
  →stringContent
endString:
  R←R append∆token STR,'"'
  →start
appendTokenAndExit:
  R←R append∆token TOK
∇

⍝ a value type is represented by a scalar like
⍝ ┌→────────────────┐
⍝ │┌→─────┐ ┌→─────┐│
⍝ ││symbol│ │antani││
⍝ │└──────┘ └──────┘│
⍝ └∊────────────────┘

t∆instanceof←{(⍺[1]≡⊂⍵) ∧ (2=⍴⍺←⊃⍺)}
t∆symbol  ← {⊂'symbol' ⍵}
t∆number  ← {⊂'number' ⍵}
t∆list    ← {⊂'list'   ⍵}
t∆string  ← {⊂'string' ⍵}
t∆symbolp ← {⍵ t∆instanceof 'symbol'}
t∆numberp ← {⍵ t∆instanceof 'number'}
t∆listp   ← {⍵ t∆instanceof 'list'  }
t∆stringp ← {⍵ t∆instanceof 'string'}


⍝ 1 if S is the string representation of a number
∇R←r∆numberp S
  R←(0<⍴S~'.')∧(1≥+/'.'=S)∧(''≡S~'0123456789.')
∇
∇R←r∆stringp S
  R←'"'=S[1]
∇
∇R←r∆read∆atom T
  T←⊃T
  →(r∆stringp T)/string
  →(r∆numberp T)/number
  R←t∆symbol T
  →exit
string:
  R←t∆string T[1↓⍳¯1+⍴T]
  →exit
number:
  R←t∆number ⍎T
  →exit
exit:
∇

∇R←r∆read∆form TS;T
  i←0
start:
  i←i+1
  →((∊'(')≡T←⊃TS[1])/list
list:
  L←⍬
listBody:
  →(')'=T←TS[i←i+1])/listEnd
  L←L,r∆read∆form
listEnd:
  R←t∆list L
∇

∇R←r∆read∆str S
  R←r∆read∆form r∆tokenize S
∇
