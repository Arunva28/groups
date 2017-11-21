class Request {
  String location;
  String time;

  Request(this.location, this.time);

  Map toJson() {
    return {"location": location, "time": time};
  }
}
