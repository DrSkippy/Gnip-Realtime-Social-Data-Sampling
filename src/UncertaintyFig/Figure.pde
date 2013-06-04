import processing.pdf.*;

figure_un f;

int x_size = 640;
//fig 2
//int y_size = 480;
// fig 3
int y_size = 320;
//
int offset = 70;
int text_offset = 50;
// fig 2
// int y_size = 650;
int arrow_size = 6;
float squiggle = 0.6;
int line_weight = 2;
// for conf 95%
float z_alpha = 1.96;
int baseline_color = 0xFF00FF00;
int line_color = 0xFF0000FF;
int point_color = 0xFFFF0000;
int axis_color = 0xFF000000;
int bg_color = 0xFFFFFFFF;
int marker_color = 0xFFFF9900;

void setup() {
  //f = new figure_sig("fig3a.pdf", 20, 2.5);
  // set max from output when you run above
  f = new figure_sig("fig3b.pdf", 7, 2.5);
  //f = new figure_un("fig2.pdf", 40);
  //size(x_size, y_size);
  size(x_size, y_size, PDF, f.name);
  background(bg_color);
  textMode(SHAPE);
}

void draw() {
  //String[] fontList = PFont.list();
  //println(fontList);
  int x_axis = x_size - offset;
  int y_axis = y_size - offset;
  f.axes(offset, x_axis, y_axis);
  // fig 2
  // f.conf_curve(offset, int(0.98*(x_axis-offset)), int(0.95*(y_axis-offset)));
  //
  // fig 3a,b
  f.conf_curve(offset, int(0.98*(x_axis-offset)), int(0.95*(y_axis-offset)));
  exit();
  println(f.dy);
}

