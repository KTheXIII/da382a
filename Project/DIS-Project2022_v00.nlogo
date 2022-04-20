; DIS-Project2022 (temporary name-please find a better one!!)
;
;
; Version History: (set date, changes and by whom everytime you add or change something)
; 2022-04-07 Initial Template by Gion K Svedberg (gks)
; 2022-04-07 people and time: Nour Ismail, Drilon Sadiku, Nezar Sheikhi, Gabriella Pantic, Alban Islami
; 2022-04-13 Begin of first integration version 00 towards a common template, gks
;
; ************ INCLUDED FILES *****************
__includes [
    "bdi.nls"
    "regions.nls"
    ;"communication.nls"
    ;"setupvoters.nls"
    ;"proactive.nls"
  ;
  ;

]
; ********************end included files ********

; ************ EXTENSIONS *****************
extensions [
; vid ; used for recording of the simulation
array
table
]
; ********************end extensions ********


; ************ BREEDS OF TURTLES *****************
breed [voters voter]  ;

; ********************end breed of turtles ********


; ************* GLOBAL VARIABLES *****************
globals [
   time
   flagNewWeek ; true if it is a new week
   flagNewMonth ; true if it is a new month
   flagNewYear ; true if it is a new year
   day week month year
   old_day old_week old_month old_year

]

; ******************end global variables ***********


; ************* AGENT-SPECIFIC VARIABLES *********
turtles-own [
  beliefs
  intentions
  ; incoming-queue
  current_status
  current_state
  current_goal
]

voters-own [
  age
  familyList
  friendsList
  levelOfEducation ;Kan variera från 1-3 dvs PrG-G-PoG
  flagEmployed
  wage
  region ;Nödvändig för att veta vilken region en agent tillhör
  ]
; *********************end agent-specific variables *************


; ******************* SETUP PART *****************
;
to setup
  clear-all
  ; set-up things
  ;  -- set up time
  set flagNewWeek false
  set flagNewMonth false
  set flagNewYear false

  ; Create the regions


  ; Create and setup voters (functions could be included with own file 'setupvoters.nls'
        ; set the regions of the agents
        setup-regions
        ; setup of agents
            ; create the agents in the different regions
            ; createvoters-region
            setup-voters ;initial creation for right now
            setup-agentAge; set the age of the agents                                        ----DONE----
            setup-educationLevel ; set the educational level of the agents                   ----DONE----
            ; set the status of employed or unemployed of the agents
            setup-monthlyWage ; set the monthly wage of the employed agents                  ----DONE----
            ; set the political attitudes of the agents
        ;-end setup of agents
  ; --- end create and setup voters
  ;
  reset-ticks
end

; **************************end setup part *******



; ******************* TO GO/ STARTING PART ********
;
;
to go
  ;-----Outside-Observer part (some of this functionality will later be replaced by agents)

  ; Determine the time
  ; - update time
  tick
  set day floor (ticks / tickNum)
  set week floor (ticks / (tickNum * 7))
  set month floor (ticks / (tickNum * 30.437))
  set year floor (ticks / (tickNum * 365.25))
  ifelse (week > old_week) [set flagNewWeek true] [set flagNewWeek false]
  ifelse (month > old_month) [set flagNewMonth true] [set flagNewMonth false]
  ifelse (year > old_year) [set flagNewYear true] [set flagNewYear false]
  set old_day day
  set old_week week
  set old_month month
  set old_year year

  ; Sending political messages to random selection of agents


  ; Changing the status of some random unemployed adults to employed

  ; Changing the status of some random employed adults to employed

  ;-----End Outside-Observer ---

  ;---- Agents to-go part -------------
  ; Cyclic execution of what the agents are supposed to do
  ; Trying to implement a Hybrid-Agent architecture with a ractive part running the intentions on
  ; the intention stack and the proactive part with a deliberation of status, states and goals
;
 ; Ask agents to do something.
  ask voters [
    process-messages ; process messages in the message-queue.
    perceive-environment ; updates beliefs about the environment

    ; Execute all of the intentions on the intention-stack as reactive behaviors
    while [not empty? intentions] [execute-intentions] ; while loop that executes all of the intentions on the stack
    proactive-behavior ; finite state machine for the proactive behavior
  ]


  ;----- End Agents to-go part ----------------------------------------
  ;
  tick

  ; show/hide things
end
;************************end to go/starting part ***********


; ************** FUNCTION and REPORT PART **************
to setup-voters
   create-voters num-agents [
    setxy random-xcor random-ycor
    set shape "person" set size 2
    set intentions []
    set beliefs []

    ;Detta har vi använt för att testa enbart
    ask voters[
      set region 1 + random 3 ; 1, 2, 3
    ]
  ]
end

to show_messages

end

to setup-agentAge
  let numOfAgentsInReg1 0
  let numOfAgentsInReg2 0
  let numOfAgentsInReg3 0

  ask voters [
    (ifelse region = 1 [set numOfAgentsInReg1 numOfAgentsInReg1 + 1]
      region = 2 [set numOfAgentsInReg2 numOfAgentsInReg2 + 1]
      region = 3 [set numOfAgentsInReg3 numOfAgentsInReg3 + 1]
    )
  ]

  ;Region 1
  ;Age group 1 - 0 - 19 år 25%
  ;Age group 2 - 20 - 49 år 34%
  ;Age group 3 - 50 - 69 år 24%
  ;Age group 4 - 70+ 17%
  let numOfAgeGroup1Reg1 numOfAgentsInReg1 * 0.25
  let numOfAgeGroup2Reg1 numOfAgentsInReg1 * 0.34
  let numOfAgeGroup3Reg1 numOfAgentsInReg1 * 0.24
  let numOfAgeGroup4Reg1 numOfAgentsInReg1 * 0.17

  ;Region 2
  ;Age group 1 - 0 - 19 år 21%
  ;Age group 2 - 20 - 49 år 33%
  ;Age group 3 - 50 - 69 år 26%
  ;Age group 4 - 70+ 20%
  let numOfAgeGroup1Reg2 numOfAgentsInReg2 * 0.21
  let numOfAgeGroup2Reg2 numOfAgentsInReg2 * 0.33
  let numOfAgeGroup3Reg2 numOfAgentsInReg2 * 0.26
  let numOfAgeGroup4Reg2 numOfAgentsInReg2 * 0.2

  ;Region 3
  ;Age group 1 - 0 - 19 år 20%
  ;Age group 2 - 20 - 49 år 46%
  ;Age group 3 - 50 - 69 år 20%
  ;Age group 4 - 70+ 14%
  let numOfAgeGroup1Reg3 numOfAgentsInReg3 * 0.2
  let numOfAgeGroup2Reg3 numOfAgentsInReg3 * 0.46
  let numOfAgeGroup3Reg3 numOfAgentsInReg3 * 0.2
  let numOfAgeGroup4Reg3 numOfAgentsInReg3 * 0.14

  ;Region 1
  ask voters with [region = 1] [
    (ifelse numOfAgeGroup1Reg1 > 0 [
      set age random 20
      set numOfAgeGroup1Reg1 numOfAgeGroup1Reg1 - 1
      ]
      numOfAgeGroup2Reg1 > 0 [
        set age 20 + random 30 ;20 + random mellan 0-29 dvs 20 - 49 eftersom vi lägger på 20 i början
        set numOfAgeGroup2Reg1 numOfAgeGroup2Reg1 - 1
      ]
      numOfAgeGroup3Reg1 > 0 [
        set age 50 + random 20 ;50 + random mellan 0 - 19 dvs 50 - 69
        set numOfAgeGroup3Reg1 numOfAgeGroup3Reg1 - 1
      ]
      numOfAgeGroup4Reg1 > 0 [
        set age 70 + random 31 ;70 + random mellan 0 - 29 dvs 70 - 100 OSÄKERT var övre gräns går
        set numOfAgeGroup4Reg1 numOfAgeGroup4Reg1 - 1
      ])
  ]

  ;Region 2
  ask voters with [region = 2] [
    (ifelse numOfAgeGroup1Reg2 > 0 [
      set age random 20
      set numOfAgeGroup1Reg2 numOfAgeGroup1Reg2 - 1
      ]
      numOfAgeGroup2Reg2 > 0 [
        set age 20 + random 30 ;20 + random mellan 0-29 dvs 20 - 49 eftersom vi lägger på 20 i början
        set numOfAgeGroup2Reg2 numOfAgeGroup2Reg2 - 1
      ]
      numOfAgeGroup3Reg2 > 0 [
        set age 50 + random 20 ;50 + random mellan 0 - 19 dvs 50 - 69
        set numOfAgeGroup3Reg2 numOfAgeGroup3Reg2 - 1
      ]
      numOfAgeGroup4Reg2 > 0 [
        set age 70 + random 31 ;70 + random mellan 0 - 29 dvs 70 - 100 OSÄKERT var övre gräns går
        set numOfAgeGroup4Reg2 numOfAgeGroup4Reg2 - 1
      ])
  ]

  ;Region 3
  ask voters with [region = 3] [
    (ifelse numOfAgeGroup1Reg3 > 0 [
      set age random 20
      set numOfAgeGroup1Reg3 numOfAgeGroup1Reg3 - 1
      ]
      numOfAgeGroup2Reg3 > 0 [
        set age 20 + random 30 ;20 + random mellan 0-29 dvs 20 - 49 eftersom vi lägger på 20 i början
        set numOfAgeGroup2Reg3 numOfAgeGroup2Reg3 - 1
      ]
      numOfAgeGroup3Reg2 > 0 [
        set age 50 + random 20 ;50 + random mellan 0 - 19 dvs 50 - 69
        set numOfAgeGroup3Reg3 numOfAgeGroup3Reg3 - 1
      ]
      numOfAgeGroup4Reg2 > 0 [
        set age 70 + random 31 ;70 + random mellan 0 - 29 dvs 70 - 100 OSÄKERT var övre gräns går
        set numOfAgeGroup4Reg3 numOfAgeGroup4Reg3 - 1
      ])
  ]

end

to setup-educationLevel

  let numOfAgentsInReg1 0
  let numOfAgentsInReg2 0
  let numOfAgentsInReg3 0

  ask voters [
    (ifelse region = 1 [set numOfAgentsInReg1 numOfAgentsInReg1 + 1]
      region = 2 [set numOfAgentsInReg2 numOfAgentsInReg2 + 1]
      region = 3 [set numOfAgentsInReg3 numOfAgentsInReg3 + 1]
    )
  ]

  ;Region 1 numOfAgentsInRegion * education %
  let numOfPrG1 numOfAgentsInReg1 * 0.2
  let numOfG1 numOfAgentsInReg1 * 0.52
  let numOfPoG1 numOfAgentsInReg1 * 0.24

  ;Region 2 numOfAgentsInRegion * education %
  let numOfPrG2 numOfAgentsInReg2 * 0.14
  let numOfG2 numOfAgentsInReg2 * 0.56
  let numOfPoG2 numOfAgentsInReg2 * 0.27

  ;Region 3 numOfAgentsInRegion * education %
  let numOfPrg3 numOfAgentsInReg3 * 0.05
  let numOfG3 numOfAgentsInReg3 * 0.22
  let numOfPoG3 numOfAgentsInReg3 * 0.7


  ; Region 1: PrG = 1, G = 2, PoG = 3
  ask voters with [region = 1] [
    (ifelse numOfPog1 > 0 and age > 19 [
      set levelOfEducation 3
      set numOfPoG1 numOfPoG1 - 1
    ]
      numOfPrg1 > 0[
      set levelOfEducation 1
      set numOfPrG1 numOfPrG1 - 1
    ]
      numOfG1 > 0[
      set levelOfEducation 2
      set numOfG1 numOfG1 - 1
    ])
  ]

  ; Region 2: PrG = 1, G = 2, PoG = 3
  ask voters with [region = 2] [
    (ifelse numOfPog2 > 0  and age > 19 [
      set levelOfEducation 3
      set numOfPoG2 numOfPoG2 - 1
    ]
      numOfPrg2 > 0[
      set levelOfEducation 1
      set numOfPrG2 numOfPrG2 - 1
    ]
      numOfG2 > 0[
      set levelOfEducation 2
      set numOfG2 numOfG2 - 1
    ])
  ]

  ; Region 3: PrG = 1, G = 2, PoG = 3
  ask voters with [region = 3] [
    (ifelse numOfPog3 > 0  and age > 19 [
      set levelOfEducation 3
      set numOfPoG3 numOfPoG3 - 1
    ]
      numOfPrg3 > 0[
      set levelOfEducation 1
      set numOfPrG3 numOfPrG3 - 1
    ]
      numOfG3 > 0[
      set levelOfEducation 2
      set numOfG3 numOfG3 - 1
    ])
  ]
end

to setup-monthlyWage
  ;Region 1
  ask voters with [region = 1] [
    (ifelse age >= 16 and age <= 19 [
      set wage 18000
    ]
      age >= 20 and age <= 64 [
      set wage 20000
    ]
      age >= 65 [
      set wage 17000
    ])
  ]

  ;Region 2
  ask voters with [region = 2] [
    (ifelse age >= 16 and age <= 19 [
      set wage 20000
    ]
      age >= 20 and age <= 64 [
      set wage 21000
    ]
      age >= 65 [
      set wage 19000
    ])
  ]

  ;Region 3
  ask voters with [region = 3] [
    (ifelse age >= 16 and age <= 19 [
      set wage 23000
    ]
      age >= 20 and age <= 64 [
      set wage 24000
    ]
      age >= 65 [
      set wage 25000
    ])
  ]

end


to process-messages
; reads and interprets all the messages on the message-queue (might need a while-loop)
  ; -> updates beliefs and variables
  ; -> adds intentions (=reactive procedures) onto the intention stack
end

to perceive-environment
; rules to check through the belief-hashtable and to update variables, intentions, current_status, current_state
end



to proactive-behavior ; move this part into an own file "proactive.nls" and include it under includes
end

;************** end function and report part **************
@#$#@#$#@
GRAPHICS-WINDOW
210
10
647
448
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

SWITCH
12
416
155
449
show-intentions
show-intentions
0
1
-1000

SLIDER
11
366
183
399
num-agents
num-agents
5
100
100.0
1
1
NIL
HORIZONTAL

BUTTON
25
28
88
61
setup
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
115
30
178
63
go
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
13
295
67
355
tickNum
1.0
1
0
Number

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
NetLogo 6.2.2
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
