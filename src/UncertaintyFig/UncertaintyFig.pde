class figure_un {
  
  String name;
  float dy;
  int n;

  figure_un(String _name, int _n) {
    name = _name;
    n = _n;
  } 
  
  void arrow(int x1, int y1, int x2, int y2) {
    y1 = y_size - y1;
    y2 = y_size - y2;
    line(x1, y1, x2, y2);
    pushMatrix();
    translate(x2, y2);
    float a = atan2(x1-x2, y2-y1);
    rotate(a);
    line(0, 0, -arrow_size, -arrow_size);
    line(0, 0, arrow_size, -arrow_size);
    popMatrix();
  } 
  
  void axes(int x, int x_width, int y_height) {
    strokeWeight(2);
    stroke(axis_color);
    arrow(x, x, x_width, x);
    arrow(x, x, x, y_height);
    //
    PFont font = createFont("BookAntiqua-Bold-24.vlw", 24);
    textFont(font, 24);
    textAlign(CENTER);
    fill(0);
    pushMatrix();
    translate(60, y_size - (x + y_height)/2);
    rotate(-PI/2); 
    text("Activity Rate", 0, 0); 
    popMatrix();
    text("Time", (x + x_width)/2, y_size - 60);
  }
  
  float poisson_lbounds(int k) {
    return k*pow(1. - 1./(9.*k) - z_alpha/(3.*sqrt(k)), 3.);
  }
  
  float poisson_ubounds(int k) {
    return (k+1.)*pow(1. - 1./(9.*(k+1.)) + z_alpha/(3.*sqrt(k+1.)), 3.);
  }
  
  void conf_curve(int x_origin, int x_pixels, int y_pixels) {
    float x;
    float yu;
    float yl;
    //
    // settings
    strokeWeight(2);
    float dx = x_pixels/n;
    dy = y_pixels/poisson_ubounds(1);
    // 
    // first point
    float x_last = dx;
    float yu_last = poisson_ubounds(1)/1. * dy;
    float yl_last = poisson_lbounds(1)/1. * dy;
    stroke(baseline_color);
    line(x_origin + x_last, y_size - (x_origin + 1*dy), x_origin + n*dx, y_size - (x_origin + 1*dy));
    stroke(point_color);
    point(x_origin + x_last, y_size - (x_origin + yu_last));
    point(x_origin + x_last, y_size - (x_origin + yl_last));
    //
    for (int i=1;i<=n;i++) {
      x = i * dx;
      yu = poisson_ubounds(i)/i * dy;
      yl = poisson_lbounds(i)/i * dy;
      stroke(line_color);
      line(x_origin + x_last, y_size - (x_origin + yu_last), x_origin + x, y_size - (x_origin + yu));
      line(x_origin + x_last, y_size - (x_origin + yl_last), x_origin + x, y_size - (x_origin + yl));
      stroke(point_color);
      //point(x_origin + x, y_size - (x_origin + yu));
      //point(x_origin + x, y_size - (x_origin + yl));
      x_last = x;
      yu_last = yu;
      yl_last = yl;
    }
  }
}

