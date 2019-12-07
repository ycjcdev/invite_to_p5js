//demo
boolean isDemo = false;
int demoVal = 0;

//グローバル変数-------------------------------------------

//particleの数
int NB_PARTICLES = 300;

ArrayList<Triangle> triangles;

//particleインスタンス配列
Particle[] particles = new Particle[NB_PARTICLES];


// 設定
boolean isReactToSound = true;
boolean isDisplayParticle = false;
boolean isDisplayArea = false;
boolean isDisplayTriangle = true;
boolean isMove = true;

//-------------------------------------------------------

void setup(){
   //フルスクリーンで実行
   // fullScreen(P2D);
   size(screen.width,screen.height);
   // particleインスタンス生成
   for (int i = 0; i < NB_PARTICLES; i++){
      particles[i] = new Particle();
   }
   frameRate(60);
   // Audio処理セッティング
   // audioSetting();

   if(isDemo){
      NB_PARTICLES = 50;
      strokeWeight(2);
   }
}

void draw(){

   if(isDemo){
      switch(demoVal) {
         case 0:
         isDisplayParticle = true;
         isDisplayArea = false;
         isDisplayTriangle = false;
         break;

         case 1:
         isDisplayParticle = true;
         isDisplayArea = true;
         isDisplayTriangle = false;
         break;

         case 2:
         isDisplayParticle = true;
         isDisplayArea = true;
         isDisplayTriangle = true;
         break;
         default:
         break;
      }
   }

   //背景を描画
   background(255);

   // 三角形を描画
   drawTriangles(156,21,212);

   // 点を描画
   drawParticles();
}


// DIST_MAX範囲内のparticleを探し、三角形の頂点とする
void setVertex(){

   Particle p1, p2;

   // ２重for文で全てのparticleの組み合わせを比較
   for (int i = 0; i < NB_PARTICLES; i++){
      p1 = particles[i];
      p1.neighboors = new ArrayList<Particle>();
      p1.neighboors.add(p1);

      for (int j = i+1; j < NB_PARTICLES; j++){
         // 比較対象
         p2 = particles[j];

         // p1とp2の距離
         float d = PVector.dist(p1.pos, p2.pos);

         // p1とp2の距離がDIST_MAX範囲内なら、p1.neighboorsにp2をadd
         if (0 < d && d < Particle.DIST_MAX){
            p1.neighboors.add(p2);
         }
      }

      // neighboorsの数が１より大きい（DIST_MAX内に他のparticleが存在する）場合
      // addTrianglesにneighboorsを渡す
      if(p1.neighboors.size() > 1){
         addTriangles(p1.neighboors);
      }
   }
}

// 三角形を描画
void drawTriangles(int R,int G,int B){

   // Triangleのリストを初期化
   triangles = new ArrayList<Triangle>();

   //三角形の頂点を探す
   setVertex();

   // 色を設定
   setColor(R,G,B);


   //三角形を描画
   if(isDisplayTriangle){
      for (int i = 0; i < triangles.size(); i ++){
         Triangle t = triangles.get(i);
         t.display();
      }
   }

   //particleを動かす
   if(isMove){
      for (int i = 0; i < NB_PARTICLES; i++){
         particles[i].move();
      }
   }
}

// 色を設定
void setColor(int R,int G,int B){

   // 塗り色を設定
   float fillAlphaValue;
   if(isReactToSound == true){
      fillAlphaValue = 15;
      fill(R, G, B, fillAlphaValue);

      // 線の色を設定
      float strokeAlphaValue;
      if(isReactToSound == true){
         strokeAlphaValue = 15;
         if(!isDemo){
            stroke(R-10,G-10,B-10,strokeAlphaValue);
         }else{
            stroke(255,0,0);
         }

      }
   }
}


void addTriangles(ArrayList<Particle> p_neighboors){
         //sはneighboorsの数
         int nSize = p_neighboors.size();

         // 頂点neighboors.get(0)に対し、頂点neighboors.get(1)以降を頂点として３角形を描画
         // e.g. get(0),get(1),get(2) / get(0),get(2),get(3)
         if (nSize > 2){
            for (int i = 1; i < nSize-1; i ++){
               for (int j = i+1; j < nSize; j ++){
                  triangles.add(new Triangle(p_neighboors.get(0).pos, p_neighboors.get(i).pos, p_neighboors.get(j).pos));
               }
            }
         }
      }

      void drawParticles(){
         // particleインスタンス生成
         for (int i = 0; i < NB_PARTICLES; i++){
            if(isDisplayParticle){
               particles[i].displayParticle();
            }
            if(isDisplayArea){
               particles[i].displayArea();
            }
         }
      }

      void keyPressed() {
         if (key == CODED) {
            if (keyCode == UP) {
               demoVal += 1;
            } else if (keyCode == DOWN) {
               demoVal -= 1;
            }
         }
      }
// Particle（粒子）クラス
class Particle{
   final static float RAD = 10;//半径
   final static float BOUNCE = -1;//跳ね返らせる（逆ベクトルに変換する）ための定数
   final static float SPEED_MAX = 2.2;//移動スピード
   final static float DIST_MAX = 100;//三角形の頂点を拾う範囲
   boolean isDisplayArea = false;
   boolean isDisplayParticle = false;
   PVector speed = new PVector(random(-SPEED_MAX, SPEED_MAX),
      random(-SPEED_MAX, SPEED_MAX));
   PVector pos;//position 位置ベクトルを保持する。

   //DIST_MAX範囲内のParticleを、自身と併せて入れる為のリスト
   ArrayList<Particle> neighboors;

   Particle(){
      pos = new PVector (random(width), random(height));
   }

   //Particleを動かす
   public void move(){
      pos.add(speed);

      //当たり判定処理
      if (pos.x < 0)
      {
         pos.x = 0;
         speed.x *= BOUNCE;
      }
      else if (pos.x > width)
      {
         pos.x = width;
         speed.x *= BOUNCE;
      }
      if (pos.y < 0)
      {
         pos.y = 0;
         speed.y *= BOUNCE;
      }
      else if (pos.y > height)
      {
         pos.y = height;
         speed.y *= BOUNCE;
      }
   }

   //Particleを描画する
   public void displayParticle(){
      stroke(0);
      fill(0);
      ellipse(pos.x, pos.y, RAD, RAD);
   }

   public void displayArea(){
      fill(0,15);
      ellipse(pos.x, pos.y, DIST_MAX * 2, DIST_MAX * 2);
   }
}

class Triangle
{
   //頂点座標をベクトルで保持する。
   PVector A, B, C;

   Triangle(PVector p1, PVector p2, PVector p3){
      A = p1;
      B = p2;
      C = p3;
   }

   public void display(){
      // 描画する図形の種類を指定
      beginShape(TRIANGLES);

      // 頂点座標を指定して描画する
      vertex(A.x, A.y);
      vertex(B.x, B.y);
      vertex(C.x, C.y);

      endShape();
   }
}
