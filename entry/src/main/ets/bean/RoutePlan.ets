export class Step {
  instruction?: string;
  orientation?: string;
  distance?: string;
  tolls?: string;
  toll_distance?: string;
  toll_road?: string[];
  duration?: string;
  polyline?: string;
  action?: string;
  assistant_action?: string;
}

export class Path {
  distance?: string;
  duration?: string;
  strategy?: string;
  tolls?: string;
  toll_distance?: string;
  steps?: Step[];
  restriction?: string;
  traffic_lights?: string;
}

export class Route {
  origin?: string;
  destination?: string;
  paths?: Path[];
}

export class RouteResponse {
  status?: string;
  info?: string;
  infocode?: string;
  count?: string;
  route?: Route;
}
