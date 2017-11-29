#! apl --script

∇R←r∆openparenp C
  R←C='('
∇
∇R←r∆closeparenp C
  R←C =')'
∇

∇R←r∆digitp C
  R←C∊'0123456789'
∇

∇R←r∆read∆str S
∇

∇R←L append T
  R←L
  →(0 = ≡T )/exit
  R←L,⊂T
exit:
∇

∇R← V t∆instanceof T
  X←⊃V
  shapeAndDepthOk←((⍴X) = 2)
  typeOk←X[1] ≡ ⊂T
  R←shapeAndDepthOk ∧ typeOk
∇

∇R←t∆symbolp SYM
  R←SYM t∆instanceof 'symbol'
∇
∇R←t∆symbol S
  ⍝ TODO assert depth ≡S = 1
  R←⊂'symbol' S
∇

∇R←t∆number N
  R←⊂'number' N
∇
∇R←t∆numberp N
  N t∆instanceof 'number'
∇

∇test N
  →(N=1 2 3)/one two three
  →other
one:
  'one!'
  →exit
two:
  'two!'
  →exit
three:
  'three!'
  →exit
other:
  'other?'
exit:
∇

∇R←r∆tokenize S
  i←0
  R←⍬
  TOK←⍬
start:
  i←i+1
  →(i > ⍴S)/appendTOKandExit
  C←S[i]
  →(C ∊ "'`&@~[](){}")/appendTokenAndChar
  →(C ∊ ' ')/whitespace
  →(C ∊ '"')/string
  →numberOrSymbol
whitespace:
  →(TOK≢⍬)/appendToken
  →start
appendToken:
  R←R append TOK
  TOK←⍬
  →start
appendTokenAndChar:
  →(TOK≡⍬)/appendChar
  R←R append TOK
  TOK←⍬
appendChar:
  R←R append 1⍴C
  →start
numberOrSymbol:
  TOK←TOK,C
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
  i←i+1
  'reading escape' S[i]
  C←1↑(S[i] = 'rntba')/(⎕ucs 13 10 9 8 7)
  STR←STR,C
  →stringContent
endString:
  R←R append STR,'"'
  →start
appendTOKandExit:
  →(TOK≡⍬)/exit
  R←R append TOK
exit:
∇
