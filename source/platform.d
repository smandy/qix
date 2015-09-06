import std.stdio;

private import derelict.sdl2.sdl;

import std.math;
import std.conv;

pragma(lib, "DerelictUtil.lib");
pragma(lib, "DerelictSDL2.lib");

const int Width=800, Height=600;

SDL_Window   *window;
SDL_Renderer *renderer;

void drawScene() {
  SDL_SetRenderDrawColor( renderer, 0, 0, 0, 0);
  SDL_RenderClear(renderer);
  SDL_SetRenderDrawColor( renderer, 0, 255, 255, 255);
  drawPlayer();
}

SDL_Point[5] points;

Player player;

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
  SDL_RenderPresent(renderer);
};

void InitGL(int Width, int Height)
{
  window = SDL_CreateWindow("Vortex", SDL_WINDOWPOS_CENTERED,
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
  InitGL(Width, Height);
  
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
    
    drawScene();
  }
  SDL_Quit();
  return;
};
