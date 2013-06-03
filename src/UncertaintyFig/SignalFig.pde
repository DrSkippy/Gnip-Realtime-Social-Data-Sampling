class figure_sig extends figure_un {
  
  float pre_dy;
  
  figure_sig(String _name, float _dy) {
    super(_name); 
    pre_dy = _dy;
  } 
  
  float sigmoid(float t, float dt, float dr) {
    // doubles from 1 to 2
    return 1. + dr/(1. + exp(dt-t));
  }
  
  void conf_curve(int x_origin, int x_pixels, int y_pixels, int n) {
    float x;
    float y;
    float yu;
    float yl;
    float dt = 7;
    float dr = 5;
    //
    // settings
    strokeWeight(2);
    float dx = x_pixels/(2.*dt);
    if (pre_dy == 0) {
      dy = y_pixels/(n*(1. + dr) + poisson_ubounds(int(n*(1. + dr))));
    } else {
      dy = pre_dy;
    }
    // 
    // first point
    float x_last = 0;
    float rate = n;
    float y_last = rate * dy;
    float yu_last = (rate + poisson_ubounds(int(rate))) * dy;
    float yl_last = (rate - poisson_lbounds(int(rate))) * dy;
    //stroke(baseline_color);
    //line(x_origin + x_last, y_size - (x_origin + 1*dy), x_origin + n*dx, y_size - (x_origin + 1*dy));
    stroke(point_color);
    point(x_origin + x_last, y_size - (x_origin + yu_last));
    point(x_origin + x_last, y_size - (x_origin + yl_last));
    point(x_origin + x_last, y_size - (x_origin + y_last));
    //
    for (int i=1;i<=2*dt;i++) {
      x = i * dx;
      rate = n * sigmoid(i, dt, dr);
      yu = (rate + poisson_ubounds(int(rate))) * dy;
      yl = (rate - poisson_lbounds(int(rate))) * dy;
      y = rate * dy;
      stroke(line_color);
      line(x_origin + x_last, y_size - (x_origin + yu_last), x_origin + x, y_size - (x_origin + yu));
      line(x_origin + x_last, y_size - (x_origin + yl_last), x_origin + x, y_size - (x_origin + yl));
      stroke(baseline_color);
      line(x_origin + x_last, y_size - (x_origin + y_last), x_origin + x, y_size - (x_origin + y));
      stroke(point_color);
      point(x_origin + x, y_size - (x_origin + yu));
      point(x_origin + x, y_size - (x_origin + yl));
      point(x_origin + x, y_size - (x_origin + y));
      x_last = x;
      yu_last = yu;
      yl_last = yl;
      y_last = y;
    }
  }
}
