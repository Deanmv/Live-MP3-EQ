//EVALUATE THIS SECTION FIRST

(
//Creates a window called instructions and displays it on the front.
w = Window("Instructions",471, false, scroll: false).front;

//Create a rectangle text view in the window (named "a").
a = TextView(w, Rect.new(0, 0, 470, 500));

//Create a string of text in the Text View with the following
a.string = "Live MP3 EQ - by Dean Vizer

Requirements -

This project uses the MP3 quarks plugin.  It will have to be downloaded from:

https://github.com/supercollider-quarks/MP3/archive/master.zip

put into your quarks folder:

/Users/_your-user_/Library/Application Support/SuperCollider/Quarks/Directory

and install via:

Quarks.gui;

Also you must have Lame and Curl installed. This can be tested with:

File.exists(MP3.lamepath);
File.exists(MP3.curlpath);

If either report back false they can be downloaded from here:

Curl - http://curl.haxx.se/download.html
Lame - http://www.macupdate.com/app/mac/18882/lame

Then close and re-open SuperCollider to re-test.";

(
//Create the function named "openFile".
~openFile={

	//open uGen Dialog and create the arguement "path".
	Dialog.openPanel({ arg path;

	//Create function "path" and save actual path to it.
	~path = path;

	//Display in post window what "path" is (just as a check).
	path.post;

	//Create a buffer "b" with ~path as the path
	b = MP3.readToBuffer(s, ~path);

	},{

	//Just post cancel if the dialog box is closed without selecting a file.
    "cancelled".postln;

	})
};
//Boot the server.
s.boot;
)
)
//EVALUATE THIS SECTION FIRST

//EVALUATE THIS SECTION SECOND THEN RUN ALL FROM GUI
(

//Create the variables "playButton" and "openButton".
var playButton, openButton;

//Create a SynthDef called Mp3Control.
SynthDef(\Mp3Control,{|buffer=0|

	//Create the variable "signal".
	var signal;

	    //Make "signal" = BPeakEQ with the buffer as the audio source.
		signal = BPeakEQ.ar(
			PlayBuf.ar(buffer.numChannels,buffer,1),

			//freq linked to MouseX, range from 0hz to 15Khz.
			freq: MouseX.kr(0,15000,0,0.1) ,

			//dB is linked to MouseY, range from -60 to +12.
			db: MouseY.kr(12,-60,0,0.1)
		);

		//Output in stereo with "signal" variable as the source.
	Out.ar([0,1],signal);

	//store the SynthDef
}).store;

//Create a Window, with defined name and dimentions, assign it to "w".
w = Window.new("MP3 Live EQ", Rect(500, 500, 348, 78));

//Make the view have FlowLayout so buttons don't overlap.
w.view.decorator = FlowLayout.new(w.bounds);

//Create a button and assign it to openButton with certain dimensions.
openButton = Button(w, Rect(20, 20, 340, 30))

        //Define the states of the button.
        .states_([

	    //Define what the label and colours are going to be.
		["Press to pick a Song", Color.black, Color.grey ],
        ])

        //Define what action the button does.
        .action_({
	    |openButton|

	        //Post the value of picked file to the post window.
            openButton.value.postln;

	//Free the buffer.
	b.free;

	//Trigger the open file dialog box again to change song in buffer (from above).
	~openFile.value;
	});

//Create a button and assign it to playButton with certain dimensions.
playButton = Button(w, Rect(20, 20, 340, 30))

        //Define the states of the button.
        .states_([

	    //Define what the label and colours are going to be for state 1.
		["Press to Play", Color.black, Color.grey ],

		//Define what the label and colours are going to be for state 2.
		["Press to Stop", Color.black, Color.grey ]
        ])

        //Define what action the button does.
        .action_({
	    |playButton|

		    //Post the value of picked file to the post window.
	        playButton.value.postln;

	        //If the value of the button is equal to 1.
	        if(playButton.value == 1,{

		           //Open a Frequency Analyzer
		           FreqScope.new;

		           //Play the Synth about which starts the song.
		           ~play = Synth(\Mp3Control,[\buffer,b]);
	        });

	        //If the value of the button is equal to 0.
	        if(playButton.value == 0, {

		           //Free the synth which stops the song.
	               ~play.free;
            });
	     });

//Bring the window to the front and ontop of other windows.
w.front;
)
//EVALUATE THIS SECTION SECOND THEN RUN ALL FROM GUI