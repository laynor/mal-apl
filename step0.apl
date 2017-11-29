#! apl --script

)COPY 1 reader

∇loop
  INPUT←∆prompt 'user> '
  rep INPUT
  loop
∇

∇R←rep S
  AST←read S
  RES←eval AST
  R←print RES
∇

∇R←read S
  R←S
∇

∇R←eval FORM
  R←FORM
∇

∇R←print FORM
  R←FORM
∇

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Basic  utils ⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

∇R←∆prompt X
  ⍞←X←,⍕X
  R←(⍴X)↓⍞
∇

∇∆display DATA
  8⎕CR DATA
∇
