breed [people-evacuating a-person-evacuating]
breed [people-ignoring-alarm a-person-ignoring-alarm]
breed [people-panicking a-person-panicking]
breed [flocking-helpers a-flocking-helper]
breed [vocal-helpers a-vocal-helper]
breed [strong-helpers a-strong-helper]
breed [kangaroos a-kangaroo]
breed [fire-tiles a-fire-tile]

people-evacuating-own [health]
people-ignoring-alarm-own [health]
people-panicking-own [health]
flocking-helpers-own [health]
vocal-helpers-own [health shout]
strong-helpers-own [health]

globals [people-escaped people-died number-of-humans]

to setup
  clear-all
  setup-walls
  setup-people-evacuating
  setup-people-ignoring-alarm
  setup-people-panicking
  setup-flocking-helpers
  setup-vocal-helpers
  setup-strong-helpers
  set people-died 0
  setup-fire-tiles
  beep
  set people-escaped 0
  set number-of-humans number-of-people-evacuating + number-of-people-ignoring-alarm + number-of-people-panicking + number-of-flocking-helpers + number-of-vocal-helpers + number-of-strong-helpers
  reset-ticks
end

to setup-walls
  ask patches [
    set pcolor brown
  ]
  ask patches with [pxcor = 16] [
    set pcolor 32 ]
  ask patches with [pxcor = 4 and (pycor < 4 or pycor > 4) and (pycor < -4 or pycor > -4)] [
    set pcolor 32 ]
  ask patches with [pxcor = -16] [
    set pcolor 32 ]
  ask patches with [pxcor = -4 and (pycor < 4 or pycor > 4) and (pycor < -4 or pycor > -4)] [
    set pcolor 32 ]
  ask patches with [pycor = 16 and (pxcor <= -1 or pxcor >= 1) ] [
    set pcolor 32 ]
  ask patches with [pycor = 0 and (pxcor <= -4 or pxcor >= 4) ] [
    set pcolor 32 ]
  ask patches with [pycor = -16] [
    set pcolor 32 ]
end

to setup-people-evacuating
  ask n-of number-of-people-evacuating patches with [pcolor = brown][
    if (not any? people-evacuating-here) or (not any? people-ignoring-alarm-here) or (not any? people-panicking-here) or (not any? flocking-helpers-here) or (not any? vocal-helpers-here) or (not any? strong-helpers-here)[
      sprout-people-evacuating 1 [
      set shape "person"
      set color black
      set health 50
      ;set speed 1
      ]
    ]
  ]
end

to setup-people-ignoring-alarm
  ask n-of number-of-people-ignoring-alarm patches with [pcolor = brown][
    if (not any? people-evacuating-here) or (not any? people-ignoring-alarm-here) or (not any? people-panicking-here) or (not any? flocking-helpers-here) or (not any? vocal-helpers-here) or (not any? strong-helpers-here)[
      sprout-people-ignoring-alarm 1 [
      set shape "person"
      set color violet
      set health 50
      ;set speed 1
      ]
    ]
  ]
end

to setup-people-panicking
  ask n-of number-of-people-panicking patches with [pcolor = brown][
    if (not any? people-evacuating-here) or (not any? people-ignoring-alarm-here) or (not any? people-panicking-here) or (not any? flocking-helpers-here) or (not any? vocal-helpers-here) or (not any? strong-helpers-here)[
      sprout-people-panicking 1 [
      set shape "person"
      set color blue
      set health 50
      ;set speed 1
      ]
    ]
  ]
end

to setup-flocking-helpers
  ask n-of number-of-flocking-helpers patches with [pcolor = brown][
    if (not any? people-evacuating-here) or (not any? people-ignoring-alarm-here) or (not any? people-panicking-here) or (not any? flocking-helpers-here) or (not any? vocal-helpers-here) or (not any? strong-helpers-here)[
      sprout-flocking-helpers 1 [
      set shape "person"
      set color yellow
      set health 50
      ;set speed 1
      ]
    ]
  ]
end

to setup-vocal-helpers
  ask n-of number-of-vocal-helpers patches with [pcolor = brown][
    if (not any? people-evacuating-here) or (not any? people-ignoring-alarm-here) or (not any? people-panicking-here) or (not any? flocking-helpers-here) or (not any? vocal-helpers-here) or (not any? strong-helpers-here)[
      sprout-vocal-helpers 1 [
      set shape "person"
      set color 83
      set health 50
      ;set speed 1
      ]
    ]
  ]
end

to setup-strong-helpers
  ask n-of number-of-strong-helpers patches with [pcolor = brown][
    if (not any? people-evacuating-here) or (not any? people-ignoring-alarm-here) or (not any? people-panicking-here) or (not any? flocking-helpers-here) or (not any? vocal-helpers-here) or (not any? strong-helpers-here)[
      sprout-strong-helpers 1 [
      set shape "person"
      set color 93
      set health 80
      ;set ;speed 1
      ]
    ]
  ]
end

to setup-fire-tiles
  ask n-of 1 patches with [pcolor = brown and (pxcor < -4 or pxcor > 4)][
      sprout-fire-tiles 1 [
      set shape "fire"
      set color red
      ]
  ]
  ask people-evacuating [
    if count fire-tiles-here > 0 [
      set people-died people-died + 1
      die
    ]
  ]
  ask people-ignoring-alarm [
    if count fire-tiles-here > 0 [
      set people-died people-died + 1
      die
    ]
  ]
  ask people-panicking [
    if count fire-tiles-here > 0 [
      set people-died people-died + 1
      die
    ]
  ]
  ask flocking-helpers [
    if count fire-tiles-here > 0 [
      set people-died people-died + 1
      die
    ]
  ]
  ask vocal-helpers [
    if count fire-tiles-here > 0 [
      set people-died people-died + 1
      die
    ]
  ]
end

to go
  if people-escaped + people-died = number-of-humans [stop]
  move-people-evacuating
  move-people-ignoring-alarm
  move-people-panicking
  move-flocking-helpers
  move-vocal-helpers
  ;move-strong-helpers
  spread-fire
  spread-smoke
  update-health
  check-death
  tick
end

to move-people-evacuating
  ask people-evacuating [

    if patch-ahead 1 = nobody [
      set people-escaped people-escaped + 1
      die
    ]

    if any? fire-tiles-on patch-ahead 1
    [ right random 360 ]


    ifelse [pcolor] of patch-ahead 1 = brown or [pcolor] of patch-ahead 1 = grey [
      if ((distancexy -4 4) <= 2 and xcor <= -4) or (any? vocal-helpers with [distance myself <= 4] and label = "exit is here")[
        set color green
        facexy -4 4
      ]
      if ((distancexy 4 4) <= 2 and xcor >= 4) or (any? vocal-helpers with [distance myself <= 4] and label = "exit is here")[
        set color green
        facexy 4 4
      ]
      if ((distancexy -4 -4) <= 2 and xcor <= -4) or (any? vocal-helpers with [distance myself <= 4] and label = "exit is here")[
        set color green
        facexy -4 -4
      ]
      if ((distancexy 4 -4) <= 2 and xcor >= 4) or (any? vocal-helpers with [distance myself <= 4] and label = "exit is here")[
        set color green
        facexy 4 -4
      ]
      if ((distancexy 0 16) <= 2) or (any? vocal-helpers with [distance myself <= 4] and label = "exit is here") [
        set color white
        facexy 0 16
      ]
      if health >= 30 [
        forward 1
      ]

      if health >= 20 and health < 30 [
        forward 0.3
      ]

      if health >= 10 and health < 20 [
        forward 0.1
      ]
;      if health < 10 [
;        set speed 0.1
;      ]

    ]
    [right random 360]

  ]
end

to move-people-ignoring-alarm
  ask people-ignoring-alarm [

;    set speed 0

    if patch-ahead 1 = nobody [
        set people-escaped people-escaped + 1
        die
    ]

     if (distancexy 0 16) <= 2 [
        set color white
        facexy 0 16
      fd 1
      ]

    if any? flocking-helpers with [distance myself <= 2] [

      set color pink
      face min-one-of flocking-helpers [distance myself]
      if patch-ahead 1 = nobody [
        set people-escaped people-escaped + 1
        die
    ]
      if ([pcolor] of patch-ahead 1 = brown) or ([pcolor] of patch-ahead 1 = grey) and (not any? fire-tiles-on patch-ahead 1)[
        if (distancexy 0 16) <= 2 [
          set color white
          facexy 0 16
        ]
        if health >= 30 [
          forward 1
        ]

        if health >= 20 and health < 30 [
          forward 0.3
        ]

        if health >= 10 and health < 20 [
          forward 0.1
        ]

;        if health < 10 [
;          set speed 0
;        ]
      ]
    ]

    if distance min-one-of fire-tiles [distance myself] <= 5 or any? neighbors with [pcolor = grey] [
      set breed people-panicking
      set shape "person"
      set color black
    ]
    ]

end

to move-people-panicking
  ask people-panicking [


    if patch-ahead 1 = nobody [
      set people-escaped people-escaped + 1
      die
    ]

    ifelse [pcolor] of patch-ahead 1 = 32
    [right random 360]
    [forward 1]

        if any? flocking-helpers with [distance myself <= 2] [
      set color 133
      face min-one-of flocking-helpers [distance myself]
      if patch-ahead 1 = nobody [
        set people-escaped people-escaped + 1
        die
    ]
      if ([pcolor] of patch-ahead 1 = brown) or ([pcolor] of patch-ahead 1 = grey) and (not any? fire-tiles-on patch-ahead 1)[
        if (distancexy 0 16) <= 2 [
          set color white
          facexy 0 16
        ]
        if health >= 30 [
          forward 1
        ]

        if health >= 20 and health < 30 [
          forward 0.3
        ]

        if health >= 10 and health < 20 [
          forward 0.1
        ]

;        if health < 10 [
;          set speed 0
;        ]
      ]
    ]
  ]
end

to move-flocking-helpers
  ask flocking-helpers [

    if patch-ahead 1 = nobody [
      set people-escaped people-escaped + 1
      die
    ]

    if any? fire-tiles-on patch-ahead 1
    [ right random 360 ]


    ifelse [pcolor] of patch-ahead 1 = brown or [pcolor] of patch-ahead 1 = grey [
      if ((distancexy -4 4) <= 2 and xcor <= -4) or (any? vocal-helpers with [distance myself <= 4] and label = "exit is here") [
        set color green
        facexy -4 4
      ]
      if ((distancexy 4 4) <= 2 and xcor >= 4) or (any? vocal-helpers with [distance myself <= 4] and label = "exit is here")[
        set color green
        facexy 4 4
      ]
      if ((distancexy -4 -4) <= 2 and xcor <= -4) or (any? vocal-helpers with [distance myself <= 4] and label = "exit is here")[
        set color green
        facexy -4 -4
      ]
      if ((distancexy 4 -4) <= 2 and xcor >= 4) or (any? vocal-helpers with [distance myself <= 4] and label = "exit is here")[
        set color green
        facexy 4 -4
      ]
      if ((distancexy 0 16) <= 2) or (any? vocal-helpers with [distance myself <= 4] and label = "exit is here") [
        set color white
        facexy 0 16
      ]
      if health >= 30 [
        forward 1
      ]

      if health >= 20 and health < 30 [
        forward 0.3
      ]

      if health >= 10 and health < 20 [
        forward 0.1
      ]

;      if health < 10 [
;        set speed 0
;      ]

    ]
    [right random 360]

  ]
end

to move-vocal-helpers
  ask vocal-helpers [
     ifelse show-shout?
  [set label shout]
  [set label ""]

    if patch-ahead 1 = nobody [
      set people-escaped people-escaped + 1
      die
    ]

    if any? fire-tiles-on patch-ahead 1
    [ right random 360 ]


    ifelse [pcolor] of patch-ahead 1 = brown or [pcolor] of patch-ahead 1 = grey [
      if (distancexy -4 4) <= 2 and xcor < -4[
        set color green
        set shout "exit is here"
        facexy -4 4
      ]
      if (distancexy 4 4) <= 2 and xcor > 4[
        set color green
        set shout "exit is here"
        facexy 4 4
      ]
      if (distancexy -4 -4) <= 2 and xcor < -4[
        set color green
        set shout "exit is here"
        facexy -4 -4
      ]
      if (distancexy 4 -4) <= 2 and xcor > 4[
        set color green
        set shout "exit is here"
        facexy 4 -4
      ]
      if (distancexy 0 16) <= 2 [
        set color white
        set shout "exit is here"
        facexy 0 16
      ]
      if health >= 30 [
        forward 1
      ]

      if health >= 20 and health < 30 [
        forward 0.3
      ]

      if health >= 10 and health < 20 [
        forward 0.1
      ]


    ]
    [right random 360]

    if ( pxcor = -4 and pycor = 4) or ( pxcor = 4 and pycor = 4) or ( pxcor = -4 and pycor = -4) or ( pxcor = 4 and pycor = -4) or ( pxcor = 0 and pycor = 16) [
      set shout ""
    ]



  ]
end

;to move-strong-helpers
;  ask strong-helpers [
;  ifelse count turtles-here <= 2 [
;    if any? people-evacuating with [distance myself <= 2 and speed < [speed] of myself] [
;      face min-one-of people-evacuating with [distance myself <= 2 and speed < [speed] of myself] [distance myself]
;      if ([pcolor] of patch-ahead 1 = brown) or ([pcolor] of patch-ahead 1 = grey) and (not any? fire-tiles-on patch-ahead 1) [
;        forward speed
;        if count people-evacuating-here with [speed < [speed] of myself] > 0 [
;          ask people-evacuating-here [
;              face myself
;              set speed [speed] of strong-helpers-here
;            ]
;          set breed kangaroos
;          set shape "dog"
;          set color brown
;          set speed speed - 0.2
;            ;move-kangaroos [speed]
;        ]
;
;    ]
;;  or (any? people-ignoring-alarm with [distance myself <= 2 and speed < [speed] of myself])
;;  or (any? people-panicking with [distance myself <= 2 and speed < [speed] of myself])
;;  or (any? flocking-helpers with [distance myself <= 2 and speed < [speed] of myself])
;;  or (any? vocal-helpers with [distance myself <= 2 and speed < [speed] of myself]))
;;  and count turtles-here <= 2
;
;    ]
;  ]
;  []
;  ]
;end

to move-kangaroos [speed-parameter]

end

to spread-fire
  ask n-of 4 patches with [pcolor = brown or pcolor = grey][
    if any? neighbors with [count fire-tiles-here > 0] [
      sprout-fire-tiles 1 [
        set shape "fire"
        set color red
      ]
    ]
  ]
end

to spread-smoke
  ask fire-tiles [
    ask neighbors with [pcolor = brown and pcolor != grey][
      set pcolor grey
      ]
    ]
  ask n-of 8 patches with [pcolor = brown or pcolor = grey] [
    if any? neighbors with [pcolor = grey] [
      set pcolor grey
    ]
  ]
end

to update-health
  ask people-evacuating [
    if pcolor = grey [
     set health health - 1
    ]
  ]
  ask people-ignoring-alarm [
    if pcolor = grey [
     set health health - 1
    ]
  ]
  ask people-panicking [
    if pcolor = grey [
     set health health - 1
    ]
  ]
  ask flocking-helpers [
    if pcolor = grey [
     set health health - 1
    ]
  ]
  ask vocal-helpers [
    if pcolor = grey [
     set health health - 1
    ]
  ]
end

 to check-death
  ask people-evacuating [
    ;set health 8
    if count fire-tiles-here > 0 [
      set people-died people-died + 1
      die
    ]
    if health <= 0 [
      set people-died people-died + 1
      die ]
    if sum [count fire-tiles-here] of neighbors = 8 [
      set people-died people-died + 1
      die
    ]

  ifelse show-health?
  [set label health]
  [set label ""]
  ]

  ask people-ignoring-alarm [
    ;set health 8
    if count fire-tiles-here > 0 [
      set people-died people-died + 1
      die
    ]
    if health <= 0 [
      set people-died people-died + 1
      die ]
    if sum [count fire-tiles-here] of neighbors = 8 [
      set people-died people-died + 1
      die
    ]

  ifelse show-health?
  [set label health]
  [set label ""]
  ]

  ask people-panicking [
    ;set health 8
    if count fire-tiles-here > 0 [
      set people-died people-died + 1
      die
    ]
    if health <= 0 [
      set people-died people-died + 1
      die ]
    if sum [count fire-tiles-here] of neighbors = 8 [
      set people-died people-died + 1
      die
    ]

  ifelse show-health?
  [set label health]
  [set label ""]
  ]

  ask flocking-helpers [
    ;set health 8
    if count fire-tiles-here > 0 [
      set people-died people-died + 1
      die
    ]
    if health <= 0 [
      set people-died people-died + 1
      die ]
    if sum [count fire-tiles-here] of neighbors = 8 [
      set people-died people-died + 1
      die
    ]

  ifelse show-health?
  [set label health]
  [set label ""]
  ]

  ask vocal-helpers [
    ;set health 8
    if count fire-tiles-here > 0 [
      set people-died people-died + 1
      die
    ]
    if health <= 0 [
      set people-died people-died + 1
      die ]
    if sum [count fire-tiles-here] of neighbors = 8 [
      set people-died people-died + 1
      die
    ]

  ifelse show-health?
  [set label health]
  [set label ""]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
797
11
1381
596
-1
-1
17.455
1
10
1
1
1
0
0
0
1
-16
16
-16
16
1
1
1
ticks
30.0

BUTTON
18
220
81
253
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
96
219
159
252
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
16
20
231
53
number-of-people-evacuating
number-of-people-evacuating
0
100
0.0
1
1
NIL
HORIZONTAL

SWITCH
224
136
370
169
show-health?
show-health?
1
1
-1000

MONITOR
18
268
153
313
NIL
people-escaped
17
1
11

MONITOR
176
268
254
313
NIL
people-died
17
1
11

PLOT
16
331
644
570
Totals
time
totals
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"people-escaped" 1.0 0 -16777216 true "" "plot people-escaped"
"people-died" 1.0 0 -7500403 true "" "plot people-died"

SLIDER
492
20
724
53
number-of-people-ignoring-alarm
number-of-people-ignoring-alarm
0
100
0.0
1
1
NIL
HORIZONTAL

MONITOR
279
268
397
313
NIL
number-of-humans
17
1
11

SLIDER
266
21
470
54
number-of-people-panicking
number-of-people-panicking
0
100
0.0
1
1
NIL
HORIZONTAL

SLIDER
57
80
255
113
number-of-flocking-helpers
number-of-flocking-helpers
0
100
0.0
1
1
NIL
HORIZONTAL

SLIDER
271
81
457
114
number-of-vocal-helpers
number-of-vocal-helpers
0
100
30.0
1
1
NIL
HORIZONTAL

SWITCH
391
135
517
168
show-shout?
show-shout?
0
1
-1000

SLIDER
476
79
669
112
number-of-strong-helpers
number-of-strong-helpers
0
100
0.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dog
false
0
Polygon -7500403 true true 300 165 300 195 270 210 183 204 180 240 165 270 165 300 120 300 0 240 45 165 75 90 75 45 105 15 135 45 165 45 180 15 225 15 255 30 225 30 210 60 225 90 225 105
Polygon -16777216 true false 0 240 120 300 165 300 165 285 120 285 10 221
Line -16777216 false 210 60 180 45
Line -16777216 false 90 45 90 90
Line -16777216 false 90 90 105 105
Line -16777216 false 105 105 135 60
Line -16777216 false 90 45 135 60
Line -16777216 false 135 60 135 45
Line -16777216 false 181 203 151 203
Line -16777216 false 150 201 105 171
Circle -16777216 true false 171 88 34
Circle -16777216 false false 261 162 30

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fire
false
0
Polygon -7500403 true true 151 286 134 282 103 282 59 248 40 210 32 157 37 108 68 146 71 109 83 72 111 27 127 55 148 11 167 41 180 112 195 57 217 91 226 126 227 203 256 156 256 201 238 263 213 278 183 281
Polygon -955883 true false 126 284 91 251 85 212 91 168 103 132 118 153 125 181 135 141 151 96 185 161 195 203 193 253 164 286
Polygon -2674135 true false 155 284 172 268 172 243 162 224 148 201 130 233 131 260 135 282

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

smoke
false
0
Polygon -7500403 true true 75 165 75 165 75 165 75 165 75 165 75 165 75 165 75 165 75 165 75 165 75 165 75 150 73 134 88 104 73 44 78 14 103 -1 193 -1 223 29 208 89 208 119 210 120 210 135 210 150 210 165 210 150 210 150 210 150 210 135 210 135 210 150 210 150 210 165 210 165 210 150 210 150 210 150 208 164 208 194 210 210 225 240 225 255 225 270 238 299 225 285 195 270 195 270 195 270 195 270 195 255 180 255 165 240 150 225 135 210 120 180 90 180 75 165 75 165

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
