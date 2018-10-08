/*
16 ( year 8 * 2 ( old shit ) + ( new trick ) )

TriangleStrip16S
OG: http://fix400.tumblr.com/post/74207786552/trianglestrip


*/
import javafx.scene.canvas.*;
import javafx.scene.effect.*;
import javafx.scene.paint.*;
import javafx.scene.shape.*;
import javafx.scene.text.*;

import fixlib.*;


Fixlib fix = Fixlib.init(this);
String SAVE_NAME = "thisShouldBeDynamic";
float cX, cY;

GraphicsContext ctx;
DropShadow fxDropShadow;
InnerShadow fxInnerShadow;
//  A value of null is treated as pass-though this means no effect on a parent such as a Group and the equivalent of SRC_OVER for a single Node.
//  SRC_OVER = DEFAULT, use while concepting

//  16 BlendModes : Run final sketch through all 16 BlendModes
//  ADD, BLUE, COLOR_BURN, COLOR_DODGE, DARKEN, DIFFERENCE, EXCLUSION, GREEN, 
//  HARD_LIGHT, LIGHTEN, MULTIPLY, OVERLAY, RED, SCREEN, SOFT_LIGHT, SRC_ATOP

//  TODO: automate MASTER run that runs sketch for 16 BlendModes 
//  => not SRC_OVER since that's the default concepting BlendMode

//  BlendMode bMode = BlendMode.ADD;
//  BlendMode bMode = BlendMode.BLUE;
//  BlendMode bMode = BlendMode.COLOR_BURN;
//  BlendMode bMode = BlendMode.COLOR_DODGE;
//  BlendMode bMode = BlendMode.DARKEN;
//  BlendMode bMode = BlendMode.DIFFERENCE;
//  BlendMode bMode = BlendMode.EXCLUSION;
//  BlendMode bMode = BlendMode.GREEN;
//  BlendMode bMode = BlendMode.HARD_LIGHT;
//  BlendMode bMode = BlendMode.LIGHTEN;
//  BlendMode bMode = BlendMode.MULTIPLY;
//  BlendMode bMode = BlendMode.OVERLAY;
//  BlendMode bMode = BlendMode.RED;
//  BlendMode bMode = BlendMode.SCREEN;
//  BlendMode bMode = BlendMode.SOFT_LIGHT;
//  BlendMode bMode = BlendMode.SRC_ATOP;

BlendMode bMode = BlendMode.SRC_OVER; // default

/* ------------------------------------------------------------------------- */
//  major settings
float outerRad = 80;  //24;//min(width, height) * 0.4;
float innerRad = 24;  //11;//outerRad * 0.6;
float getRadder = 69; // increase radii by this much each pass
float pts = 36; //72; //8;
float rot = 360.0/pts;

//  internals
float angle = 0;
PVector pVec;

/* ------------------------------------------------------------------------- */

void  settings ()  {
    size(1920, 1080, FX2D); // FX2D required
    smooth(8);  //  smooth() can only be used in settings();
    pixelDensity(displayDensity());
}

/*****************************************************************************/
void setup() 
{
  background(#EFEFEF);

  ellipseMode(CENTER);
  rectMode(CENTER);

  cX = width/2;
  cY = height/2;

  
  fxInnerShadow = new InnerShadow();
  fxDropShadow = new DropShadow();

  //  NEW TRICK - save sketch settings into output file name for revisiting
  //  with popular settings.
  //  Generate filename containing sketch settings meta NOW
  SAVE_NAME = fix.pdeName() + 
              "-bMode" + bMode + 
              "-outerRad"+ outerRad +
              "-innerRad"+ innerRad +
              "-getRadder"+ getRadder +
              "-pts"+ pts +
              "-rot"+ rot + fix.getTimestamp();



  //see: https://docs.oracle.com/javase/10/docs/api/javafx/scene/canvas/GraphicsContext.html
  ctx = ((Canvas) surface.getNative()).getGraphicsContext2D();


// JAVAFX CSS: https://docs.oracle.com/javafx/2/api/javafx/scene/doc-files/cssref.html

//  TODO: work with BlendMode
ctx.setGlobalBlendMode(bMode);
// ctx.setFillRule(FillRule.NON_ZERO);    
// ctx.setMiterLimit(1.0); //  default = 10.0
// ctx.setFontSmoothingType( FontSmoothingType.LCD );


}



/*****************************************************************************/
void draw() {

//  SKETCH HERE



while( outerRad < height ) {

    
  //  JAVAFX HERE
  fxDropShadow.setOffsetX(frameCount%8f);
  fxDropShadow.setOffsetY(frameCount%8f);

  fxInnerShadow.setOffsetX(frameCount%8f);
  fxInnerShadow.setOffsetY(frameCount%8f);

  //  mix up inner shadow color
  fxDropShadow.setColor(Color.rgb((frameCount%255), (frameCount%255), (frameCount%255) ) );
  fxInnerShadow.setColor(Color.rgb((frameCount%255), (frameCount%255), (frameCount%255) ) );
    
  //  APPLY EFFECTS - order matters
  ctx.setEffect(fxInnerShadow);
  ctx.setEffect(fxDropShadow);

  
  beginShape(TRIANGLE_STRIP); 
    for (int i = 0; i < pts; i++) 
    {
      //  NEW TRICK
      pVec = fix.circleXY( cX, cY, outerRad, angle );
      vertex( pVec.x, pVec.y );
      angle += rot;


      // NEW TRICK - reuse for innerRad
      pVec = fix.circleXY( cX, cY, innerRad, angle );
      vertex( pVec.x, pVec.y );

      angle += rot;
    }
  endShape();
 
  //  make bigger
  innerRad += getRadder;
  outerRad += getRadder;
}



    noLoop();
    doExit();
  
}



/* ------------------------------------------------------------------------- */
/*  NON - P5 BELOW  */
/* ------------------------------------------------------------------------- */

/**
  End of sketch closer
*/
void doExit(){
  String msg = "ERICFICKES.com ";
  //  stamp bottom right based on textSize
  fill(#EF1975);
  textSize(13);
  text(msg, width-(textWidth(msg)+textAscent()), height-textAscent());
  
  save(SAVE_NAME+".png"); //  USE .TIF IF COLOR  
  
  //  cleanup
  fix = null;
  
  noLoop();
  exit();
  System.gc();
  System.exit(1);
}
