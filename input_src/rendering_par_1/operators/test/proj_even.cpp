void projection_even_m (
        bit32 input_lo,
        bit32 input_mi,
        bit32 input_hi,
        Triangle_2D *triangle_2d
        )
{
  #pragma HLS INLINE off
  Triangle_3D triangle_3d;
  // Setting camera to (0,0,-1), the canvas at z=0 plane
  // The 3D model lies in z>0 space
  // The coordinate on canvas is proportional to the corresponding coordinate
  // on space


    bit2 angle = 0;
    triangle_3d.x0(7, 0) = input_lo( 7,  0);
    triangle_3d.y0(7, 0) = input_lo(15,  8);
    triangle_3d.z0(7, 0) = input_lo(23, 16);
    triangle_3d.x1(7, 0) = input_lo(31, 24);
    triangle_3d.y1(7, 0) = input_mi( 7,  0);
    triangle_3d.z1(7, 0) = input_mi(15,  8);
    triangle_3d.x2(7, 0) = input_mi(23, 16);
    triangle_3d.y2(7, 0) = input_mi(31, 24);
    triangle_3d.z2(7, 0) = input_hi( 7,  0);

  if(angle == 0)
  {
    triangle_2d->x0 = triangle_3d.x0;
    triangle_2d->y0 = triangle_3d.y0;
    triangle_2d->x1 = triangle_3d.x1;
    triangle_2d->y1 = triangle_3d.y1;
    triangle_2d->x2 = triangle_3d.x2;
    triangle_2d->y2 = triangle_3d.y2;
    triangle_2d->z  = triangle_3d.z0 / 3 + triangle_3d.z1 / 3 + triangle_3d.z2 / 3;
  }

  else if(angle == 1)
  {
    triangle_2d->x0 = triangle_3d.x0;
    triangle_2d->y0 = triangle_3d.z0;
    triangle_2d->x1 = triangle_3d.x1;
    triangle_2d->y1 = triangle_3d.z1;
    triangle_2d->x2 = triangle_3d.x2;
    triangle_2d->y2 = triangle_3d.z2;
    triangle_2d->z  = triangle_3d.y0 / 3 + triangle_3d.y1 / 3 + triangle_3d.y2 / 3;
  }

  else if(angle == 2)
  {
    triangle_2d->x0 = triangle_3d.z0;
    triangle_2d->y0 = triangle_3d.y0;
    triangle_2d->x1 = triangle_3d.z1;
    triangle_2d->y1 = triangle_3d.y1;
    triangle_2d->x2 = triangle_3d.z2;
    triangle_2d->y2 = triangle_3d.y2;
    triangle_2d->z  = triangle_3d.x0 / 3 + triangle_3d.x1 / 3 + triangle_3d.x2 / 3;
  }
}
