# ReaChord
Reaper Chord Track (Lua Version)

Reapack Repo Url

https://github.com/xupeng1206/ReaChord/raw/main/index.xml

Demo:
![img.png](doc%2Fdemo.png)

## Quick Start
`Load files down below in reaper's action list`
~~~
1. ReaChord_Main.lua
Chord selector GUI

2. ReaChord_Act_Item2Sound.lua
Bind this script on your mouse action.

3. ReaChord_Reader.lua
Display the chord at the cursor.

4. ReaChord_Reader_Start.lua
ReaChord_Reader Starter, you may change command id if not work.
~~~

## Details
### 1. Create Track
```
Copy the ChordTrack.RTrackTemplate to your track template folder, use the track template to create track. than add your piano vst to the RECHORD_MIDI track.
```

### 2. Binding the mouse action
```
My Configure

Media Item / Left Click / Cmd(Win) + Ctrl
```
![img.png](doc%2Fmouse_action.png)
```
After binded, hold down the cmd(win)+ctrl, click the chord item, you can hear the chord sound.
```

### 3. Dock the ReaChord_Reader.lua
```
1. Open the ReaChord_Reader
2. Right click the reader ui when it show no chord, select the dock
3. Move it to the any position you like, for me, top position is good.
4. When chords show, right click can switch the display mode

PS.  most code all copy from X-Raym Region's Clock, thanks a lot.
```
![Alt text](doc%2Freader1.png)

![Alt text](doc%2Freader2.png)

```
For me, I need the ReaChord_Reader Opened when reaper start. So, I put he ReaChord_Reader_Start.lua in my gloabal startup cammand.
```
![Alt text](doc%2Fstartup.png)

### 4. Select the main scale

![Alt text](doc%2Fscale1.png)

![Alt text](doc%2Fscale2.png)

### 5. Select chords
#### 5.0 Degree line
```
Just show the note degree
```
#### 5.1 Select the chord root
```
You can change the chord root in this line, the blue note is the one you selected, and the pink note all in key, the grey note all not in key. you can pick the anyone, whatever pink or grey.
```
![Alt text](doc%2Fchord_root.png)

#### 5.2 Select the chord bass
```
You can point the bass note for this chord. such as G/F
```

![Alt text](doc%2Fchord_bass.png)

#### 5.3 Insert Length
```
You can point insert chord items length
1 B -> 1 Beat
2 B -> 2 Beat

you can try different choice than insert chord to see what is it.
```
![Alt text](doc%2Fbeat.png)

#### 5.4 Chord Map Section
##### 5.4.1 Click and Listen
```
1. Click any chord your like, you can hear the chord sound.
2. Hold down ESC can stop play chord
3. Hold down Left Shift, than click the chord btn can insert the chord item quickly
4. If chord sound too low or too high, your can change the Oct at top right Oct Drop down list.
```

![Alt text](doc%2Fmap.png)

##### 5.4.2 Find Similar Chord
```
1. Hold down Left ALT, than click the chord btn, can show the chords which two or more same note with current chord.
2. You can click the chord name, show the chord notes
```
![Alt text](doc%2Fsimilar_chords.png)

##### 5.4.3 Find the scale contain current chord
```
1. Hold down Left CTRL, than click the chord btn, can show the scales which contain current chord.
2. You can click the scale name, show the scale notes
```
![Alt text](doc%2Fchord_in_scales.png)
#### 5.5 Omit chord note
```
1. The blue note means include this note, you can click it make it be grey(omit).

PS. The first note always be grey, it's chord bass, you can't change it here.
```
![Alt text](doc%2Fvoicing.png)

#### 5.6 Shift the chord voicing
```
You can click the '<', '>' to shift the voicing
```

![Alt text](doc%2Fvoicing.png)

#### 5.7 Listen, Insert
```
1. Click Listen, can listen current voicing
2. Click Insert, can Insert the chord item to the chord track
```
#### 5.8 Piano Display
```
Just display
```

### 6. Chord Pads
`Binding Key`
![Alt text](doc%2Fpad.png)

```
1. Click the 'Init Chord Pad', it will give your 12 basic chord bas the selected scale. than you can press the binding key on keybord to trigger the chord.
```
![Alt text](doc%2Fpad_basic.png)

```
1. You can drag and drop any chord you like from Chord Map to Chord Pad.
```
![Alt text](doc%2Fpad_drag.png)

### 7. Extension Function
#### 7.1 Up/Down 1 semitone
```
1. Select some chord items
2. Click the Up/Down 1 semitone, you can shift the chord item.
```
#### 7.2 Refresh
```
1. Click Refresh, can refresh the chord item's metadata.
2. When bpm change, the chord track be mass, you can click the Refresh make the chord track adapt to the new bpm
3. When you need to add chord progression to you bank, make sure you run Refresh firstly
```

#### 7.3 Items To Markers/Regions
`It can make items to markers/regions`

![Alt text](doc%2Fmarker.png)

![Alt text](doc%2Fregion.png)

#### 7.4 Chord Progression Bank
##### 7.1 Add
```
1. Select 1 chord progression (multi chord items) in chord track.
2. Click the Add, I will show the add menu
3. name this chord progression than clock save bank, it will be stored

PS the refresh btn here same the big Refresh Btn
```
![Alt text](doc%2Fadd_bank.png)
##### 7.2 Insert
```
1. Select 1 chord progression in bank, also you can filter by name
2. click Insert, the chord progression will be inserted into chord track at cursor
```
##### 7.3 Delete
```
1. Select 1 chord progression in bank, also you can filter by name
2. click Delete, you can delete it when confirmed
```
![Alt text](doc%2Fdelete_bank.png)


## Extend
You can add new scale or chord in ReaChord_Theory.lua, and aslo looking forward to your PR. 