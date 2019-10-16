import spout.*;
Spout spout;
import codeanticode.syphon.*;
SyphonServer server;

String OS_NAME = "";
enum OS_LIST {
  WIN, MAC, OTHER
};
OS_LIST myOS;

// タイトルバーのパラメータ表示サンプル
boolean isDebugMode = false;
String normalMessage = "Normal Mode";
String debugMessage = "Debug Mode";

void settings() {
  size(800, 600, P3D);
  PJOGL.profile=1;
}

void setup() {
  // OSの判定
  OS_NAME = System.getProperty("os.name").toLowerCase();
  if (isMac()) {
    myOS = OS_LIST.MAC;
  } else if (isWindows()) {
    myOS = OS_LIST.WIN;
  } else {
    // 判定できないOSを使用していた場合は起動させない
    println("OS判定エラー");
    exit();
  }

  // 映像送信用ライブラリのインスタンス化
  if (myOS == OS_LIST.MAC) {
    server = new SyphonServer(this, "Processing Syphon");
  } else if (myOS == OS_LIST.WIN) {
    spout = new Spout(this);
    spout.createSender("Processing Spout");
  }

  // タイトルバーの文字セット
  if (isDebugMode) {
    surface.setTitle(debugMessage);
  } else {
    surface.setTitle(normalMessage);
  }
}

void draw() {
  background(230);

  // テストパターン
  noFill();
  stroke(0);
  strokeWeight(5);
  line(width/2, 0, width/2, height);
  line(0, height/2, width, height/2);
  ellipse(width/2, height/2, height*0.5, height*0.5);
  rectMode(CENTER);
  rect(width/2, height/2, height*0.75, height*0.75);
  stroke(255, 0, 0);
  strokeWeight(10);
  rect(width/2, height/2, width, height);

  // 映像を送信
  if (myOS == OS_LIST.MAC) {
    server.sendScreen();
  } else if (myOS == OS_LIST.WIN) {
    spout.sendTexture();
  }
}

// キーを押すごとにモードを切り替えてタイトルバーの文字を更新
void keyPressed() {
  isDebugMode = !isDebugMode;

  if (isDebugMode) {
    surface.setTitle(debugMessage);
  } else {
    surface.setTitle(normalMessage);
  }
}

boolean isMac() {
  return OS_NAME.startsWith("mac");
}

boolean isWindows() {
  return OS_NAME.startsWith("windows");
}
