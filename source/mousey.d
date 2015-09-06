import std.math;

struct Mousey {
  static immutable float PI      = 3.14159;
  static immutable float HALF_PI = PI / 2.0;
  static immutable float DEGREE  = PI / 180.0;

  float direction;
  float x;
  float y;

  void reset(int x_, int y_, float direction_) {
    x = x_;
    y = y_;
    direction = direction_;
  };
  
  this(int x_, int y_, float direction_ = 0.0f ) {
    reset(x_, y_, direction_);
  }

  void move( float l ) {
    x += l * cos(direction);
    y += l * sin(direction);
  };

  void turn( float angle) {
    direction += angle;
  };

  float getX() { return x; };
  float getY() { return y; };
};
