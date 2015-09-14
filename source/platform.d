import std.stdio;

import billiardball;
import mousey;

private import derelict.sdl2.sdl;

import std.math;
import std.conv;

pragma(lib, "DerelictUtil.lib");
pragma(lib, "DerelictSDL2.lib");

enum int WIDTH=800, HEIGHT=600;

SDL_Window   *window;
SDL_Renderer *renderer;

mixin template coords() {
  int x;
  int y;
};

alias BilliardBall!(WIDTH,HEIGHT,3) BBType;

struct Vortex(int N) {
  BBType bb;
  
  void tick() {
    degreeOffset += degreeDelta;
    bb.tick();
  };
  
  mixin coords;
  SDL_Point[N] points;
  Mousey m;
  float degreeOffset;
  const float degreeDelta;
  const float lengthFraction = 0.95;
    
  this(int x_, int y_,
       int dx,
       int dy,
       float degreeOffset_,
       float degreeDelta_) {
    x = x_;
    y = y_;
    degreeOffset = degreeOffset_;
    degreeDelta = degreeDelta_;
    bb = BBType(100,100, dx, dy);
  };
  
  void draw() {
    m.reset(bb.x.d,bb.y.d, 0.0);
    float l = 100;
    int idx = 0;
    while( l > 0.05 && idx<points.length) {
      points[idx] = SDL_Point(to!int(m.getX()), to!int(m.getY()));
      m.move( l );
      m.turn( Mousey.HALF_PI + degreeOffset * Mousey.DEGREE);
      l *= lengthFraction;
      ++ idx;
    }
    SDL_RenderDrawLines( renderer, points.ptr, idx);
  }
}


void drawScene() {
  SDL_SetRenderDrawColor( renderer, 0, 0, 0, 0);
  SDL_RenderClear(renderer);
  SDL_SetRenderDrawColor( renderer, 0, 255, 255, 255);
  drawPlayer();
  foreach(ref v ; vortices) {
    v.draw();
  }
  SDL_RenderPresent(renderer);
}

SDL_Point[5] points;

Player player;

alias Vortex!300 VortexType;

VortexType[5] vortices = [ VortexType(100,100, 3,4, 2.0, 0.2),
                           VortexType(150,100, 2,-3, 2.0, 0.3),
                           VortexType(200,50, 1,1, 2.0, 0.25),
                           VortexType(200,50, 3,-1, 2.0, 0.1),
                           VortexType(200,50, 2,5, 10.0, 0.15)

                           ];

void drawPlayer() {
  points[0].x = player.x;
  points[0].y = 10;
  
  points[1].x = player.x;
  points[1].y = 20;

  points[2].x = player.x + 10;
  points[2].y = 20;

  points[3].x = player.x + 10;
  points[3].y = 10;

  points[4] = points[0];
  
  SDL_RenderDrawLines( renderer, points.ptr, to!int(points.length));
};

void InitGL(int Width, int Height)
{
  window = SDL_CreateWindow("Whirligig", SDL_WINDOWPOS_CENTERED,
			    SDL_WINDOWPOS_CENTERED, Width, Height, SDL_WINDOW_SHOWN);
  if (window == null){
    writeln( "CreateWindow");
    //TTF_Quit();
    SDL_Quit();
    return;
  }
  renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
}

version(platform) {
  void main() {
    platformMain();
  };
}

struct Player {
  int x;
  int y;
};

void platformMain() {
  writefln("Loading SDL");
  DerelictSDL2.load();
  
  if ( SDL_Init( SDL_INIT_VIDEO ) < 0 ) {
    writefln("It didn't work");
  }

  writefln("It worked");
  auto NULL = cast(void*)0;

  writefln("Calling initgl\n");
  InitGL(WIDTH, HEIGHT);
  
  SDL_Event event;
  auto done = false;

  while ( !done ) {
    drawScene();

    auto haveEvent = SDL_PollEvent(&event);
    immutable lfBump    = 0.001;
    immutable degBump   = 0.03;

    if ( event.type == SDL_QUIT ) {
      done = true;
    }
    if ( event.type == SDL_KEYDOWN ) {
      if ( event.key.keysym.sym == SDLK_LEFT ) {
        player.x -= 5;
      }
      if ( event.key.keysym.sym == SDLK_RIGHT) {
        player.x += 5;
      }
    }

    foreach(ref v ; vortices) {
      v.tick();
    }
    
    drawScene();
  }
  SDL_Quit();
  return;
};
