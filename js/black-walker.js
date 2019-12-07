var walkerNum;
var walker = [];

function setup() {
  var canvas = createCanvas(windowWidth, windowHeight);
  // canvas.parent('i-stage');
  background(0);

  if (windowWidth < 480) {
    walkerNum = 5;
  } else if (windowWidth < 960) {
    walkerNum = 7;
  } else {
    walkerNum = 8;
  }

  for (var i = 0; i < walkerNum; i++) {
    walker[i] = new Walker(windowWidth, windowHeight);
  }
}

function draw() {
  for (var i = 0; i < walker.length; i++) {
    walker[i].step();
    walker[i].display();
  }
}

var Walker = function (ww, wh) {
  this.centerX = ww/2;
  this.centerY = wh/2;

  if (width < 480) {
    this.xThreshold = 135;
    this.yThreshold = 55;
    this.yExtra = 9;
  } else if (width < 960) {
    this.xThreshold = 160;
    this.yThreshold = 64;
    this.yExtra = 15;
  } else {
    this.xThreshold = 200;
    this.yThreshold = 80;
    this.yExtra = 20;
  }

  if (random(1) < 0.5) {
    this.x = random(this.centerX + this.xThreshold, ww);
  } else {
    this.x = random(0, this.centerX - this.xThreshold);
  }

  if (random(1) < 0.5) {
    this.y = random(this.centerY + this.yThreshold, ww);
  } else {
    this.y = random(0, this.centerY - this.yThreshold);
  }

  this.to = Date.now();

  this.display = function () {
    stroke(255, map(noise(this.to), 0, 1, 40, 70));
    strokeWeight(1);
    line(this.prevX, this.prevY, this.x, this.y);
    noStroke();
    fill(255, map(noise(this.to), 0, 1, 70, 100));
    ellipse(this.x, this.y, 1, 1);
  };

  this.step = function () {
    this.prevX = this.x;
    this.prevY = this.y;

    this.stepX = random(-1, 1);
    this.stepY = random(-1, 1);

    this.randomFactor = 90;
    if(random(1) < 0.03) this.randomFactor = 1000;

    this.stepSize = this.montecarlo() * this.randomFactor;
    this.stepX *= this.stepSize;
    this.stepY *= this.stepSize;

    this.x += this.stepX;
    this.y += this.stepY;

    this.checkEdges();

    this.x = constrain(this.x, 0, width-1);
    this.y = constrain(this.y, 0, height-1);
  };

  this.montecarlo = function () {
    while (true) {
      this.r1 = random(1);
      this.probability = Math.pow(1.0 - this.r1, 10);

      this.r2 = random(1);

      if (this.r2 < this.probability) {
        return this.r1;
      }
    }
  };

  this.checkEdges = function () {
    if ((this.x > this.centerX-this.xThreshold && this.x < this.centerX+this.xThreshold) && (this.y > this.centerY-this.yThreshold+this.yExtra && this.y < this.centerY+this.yThreshold)) {

      if (this.prevX <= this.centerX-this.xThreshold) {
        this.x = this.centerX - this.xThreshold;
      } else if (this.prevX >= this.centerX+this.xThreshold) {
        this.x = this.centerX + this.xThreshold;
      }

      if (this.prevY <= this.centerY-this.yThreshold+this.yExtra) {
        this.y = this.centerY - this.yThreshold+this.yExtra;
      } else if (this.prevY >= this.centerY+this.yThreshold) {
        this.y = this.centerY + this.yThreshold;
      }

      if (random(1) < 0.1) {
        if (this.prevX <= this.centerX-this.xThreshold || this.prevX >= this.centerX+this.xThreshold) {
          if (random(1) < 0.5) {
            this.y = this.centerY - this.yThreshold+this.yExtra;
          } else {
            this.y = this.centerY + this.yThreshold;
          }
        }

        if (this.prevY <= this.centerY-this.yThreshold+this.yExtra || this.prevY >= this.centerY+this.yThreshold) {
          if (random(1) < 0.5) {
            this.x = this.centerX - this.xThreshold;
          } else {
            this.x = this.centerX + this.xThreshold;
          }
        }
      }

    }
  };
};

function mousePressed() {
  clear();
  setup();
}

function windowResized() {
  clear();
  setup();
}
