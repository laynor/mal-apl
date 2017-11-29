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
  (N∊1 2 3)/one two three
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
  i←1
  R←⍬
  TOK←⍬
start:
  →(i > ⍴S)/appendTOKandExit
  C←S[i]
  →(C ∊ "'`&@~[](){}")/appendTokenAndChar
  →(C ∊ ' ')/whitespace
  →(C ∊ '"')/string
  →numberOrSymbol
whitespace:
  →(TOK≢⍬)/appendToken
  i←i+1
  →start
appendToken:
  R←R append TOK
  TOK←⍬
  i←i+1
  →start
appendTokenAndChar:
  →(TOK≡⍬)/appendChar
  R←R append TOK
  TOK←⍬
appendChar:
  R←R append 1⍴C
  i←i+1
  →start
numberOrSymbol:
  TOK←TOK,C
  i←i+1
  →start
string:
appendTOKandExit:
  →(TOK≡⍬)/exit
  R←R append TOK
exit:
∇
