class AReview {
  String name;
  String image;
  String text;
  String date;
  double rating;

  AReview(
      {this.name,
      this.image = "dummy_assets/profile_image_joya_ahsan.jpg",
      this.text,
      this.date = "21-01-2021",
      this.rating});
}

String existing_review = "It was a very good product";
double existing_rating = 2.0;

final List<AReview> reviewList = [
  AReview(
      name: "Alan Vontrotsski Samuel",
      text: "Nice , I liked it. Recommend others",
      rating: 3.0),
  AReview(
      name: "Kashem bin abu Zafar",
      text:
          """Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent tincidunt metus eget nisi feugiat, at imperdiet diam euismod. Curabitur at aliquam urna. Fusce lacinia nunc sed enim varius egestas. Mauris in dui vitae magna tempus mollis non vel magna. Donec vitae neque vitae odio congue efficitur non sed ante. Sed venenatis risus nec dui sodales molestie. Quisque vel magna nisl. Vestibulum feugiat lacus at est condimentum, vel euismod lectus efficitur. Donec quam mi, venenatis ac volutpat at, dictum id metus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Praesent efficitur dolor ac vulputate lobortis.
      Suspendisse auctor blandit diam, at pretium est vulputate quis. Suspendisse facilisis tincidunt venenatis. Curabitur quis enim ut dui eleifend dapibus ut id ante. Nulla maximus iaculis dapibus. Phasellus euismod tortor in mauris porta mattis. Aenean aliquet nisi in ipsum condimentum luctus. Integer vitae tempor nisi, at scelerisque ante. Maecenas lacinia erat erat. Phasellus at aliquet ante. Integer ut lacinia arcu. Maecenas volutpat elementum erat ut interdum. Aenean risus mi, aliquet nec tincidunt et, consequat ac felis.""",
      rating: 5.0),
  AReview(
      name: "Etu",
      text:
      """ Fusce accumsan porta libero et sollicitudin. Nullam ac felis sit amet ligula tempor consequat. Praesent interdum leo turpis, eget bibendum quam blandit quis. Phasellus eu arcu vitae elit interdum lacinia fringilla a magna. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Etiam aliquam, orci vitae maximus scelerisque, nunc sapien maximus elit, at mattis erat sem sed purus. Proin ornare sapien eu ipsum semper efficitur. Sed id malesuada mauris, ac pretium arcu. Aliquam egestas id elit in pretium. In hac habitasse platea dictumst. Donec quis porttitor velit.  """,
      rating: 1.0),

  AReview(
      name: "Alan Vontrotsski Samuel",
      text: "Nice , I liked it. Recommend others",
      rating: 3.0),
  AReview(
      name: "Kashem bin abu Zafar",
      text:
      """ Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent tincidunt metus eget nisi feugiat, at imperdiet diam euismod. Curabitur at aliquam urna. Fusce lacinia nunc sed enim varius egestas. Mauris in dui vitae magna tempus mollis non vel magna. Donec vitae neque vitae odio congue efficitur non sed ante. Sed venenatis risus nec dui sodales molestie. Quisque vel magna nisl. Vestibulum feugiat lacus at est condimentum, vel euismod lectus efficitur. Donec quam mi, venenatis ac volutpat at, dictum id metus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Praesent efficitur dolor ac vulputate lobortis.
      Suspendisse auctor blandit diam, at pretium est vulputate quis. Suspendisse facilisis tincidunt venenatis. Curabitur quis enim ut dui eleifend dapibus ut id ante. Nulla maximus iaculis dapibus. Phasellus euismod tortor in mauris porta mattis. Aenean aliquet nisi in ipsum condimentum luctus. Integer vitae tempor nisi, at scelerisque ante. Maecenas lacinia erat erat. Phasellus at aliquet ante. Integer ut lacinia arcu. Maecenas volutpat elementum erat ut interdum. Aenean risus mi, aliquet nec tincidunt et, consequat ac felis. """,
      rating: 5.0),
  AReview(
      name: "Etu",
      text:
      """ Fusce accumsan porta libero et sollicitudin. Nullam ac felis sit amet ligula tempor consequat. Praesent interdum leo turpis, eget bibendum quam blandit quis. Phasellus eu arcu vitae elit interdum lacinia fringilla a magna. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Etiam aliquam, orci vitae maximus scelerisque, nunc sapien maximus elit, at mattis erat sem sed purus. Proin ornare sapien eu ipsum semper efficitur. Sed id malesuada mauris, ac pretium arcu. Aliquam egestas id elit in pretium. In hac habitasse platea dictumst. Donec quis porttitor velit.  """,
      rating: 1.0),

  AReview(
      name: "Alan Vontrotsski Samuel",
      text: "Nice , I liked it. Recommend others",
      rating: 3.0),
  AReview(
      name: "Kashem bin abu Zafar",
      text:
      """ Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent tincidunt metus eget nisi feugiat, at imperdiet diam euismod. Curabitur at aliquam urna. Fusce lacinia nunc sed enim varius egestas. Mauris in dui vitae magna tempus mollis non vel magna. Donec vitae neque vitae odio congue efficitur non sed ante. Sed venenatis risus nec dui sodales molestie. Quisque vel magna nisl. Vestibulum feugiat lacus at est condimentum, vel euismod lectus efficitur. Donec quam mi, venenatis ac volutpat at, dictum id metus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Praesent efficitur dolor ac vulputate lobortis.
      Suspendisse auctor blandit diam, at pretium est vulputate quis. Suspendisse facilisis tincidunt venenatis. Curabitur quis enim ut dui eleifend dapibus ut id ante. Nulla maximus iaculis dapibus. Phasellus euismod tortor in mauris porta mattis. Aenean aliquet nisi in ipsum condimentum luctus. Integer vitae tempor nisi, at scelerisque ante. Maecenas lacinia erat erat. Phasellus at aliquet ante. Integer ut lacinia arcu. Maecenas volutpat elementum erat ut interdum. Aenean risus mi, aliquet nec tincidunt et, consequat ac felis. """,
      rating: 5.0),
  AReview(
      name: "Etu",
      text:
      """ Fusce accumsan porta libero et sollicitudin. Nullam ac felis sit amet ligula tempor consequat. Praesent interdum leo turpis, eget bibendum quam blandit quis. Phasellus eu arcu vitae elit interdum lacinia fringilla a magna. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Etiam aliquam, orci vitae maximus scelerisque, nunc sapien maximus elit, at mattis erat sem sed purus. Proin ornare sapien eu ipsum semper efficitur. Sed id malesuada mauris, ac pretium arcu. Aliquam egestas id elit in pretium. In hac habitasse platea dictumst. Donec quis porttitor velit.  """,
      rating: 1.0),

  AReview(
      name: "Alan Vontrotsski Samuel",
      text: "Nice , I liked it. Recommend others",
      rating: 3.0),
  AReview(
      name: "Kashem bin abu Zafar",
      text:
      """ Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent tincidunt metus eget nisi feugiat, at imperdiet diam euismod. Curabitur at aliquam urna. Fusce lacinia nunc sed enim varius egestas. Mauris in dui vitae magna tempus mollis non vel magna. Donec vitae neque vitae odio congue efficitur non sed ante. Sed venenatis risus nec dui sodales molestie. Quisque vel magna nisl. Vestibulum feugiat lacus at est condimentum, vel euismod lectus efficitur. Donec quam mi, venenatis ac volutpat at, dictum id metus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Praesent efficitur dolor ac vulputate lobortis.
      Suspendisse auctor blandit diam, at pretium est vulputate quis. Suspendisse facilisis tincidunt venenatis. Curabitur quis enim ut dui eleifend dapibus ut id ante. Nulla maximus iaculis dapibus. Phasellus euismod tortor in mauris porta mattis. Aenean aliquet nisi in ipsum condimentum luctus. Integer vitae tempor nisi, at scelerisque ante. Maecenas lacinia erat erat. Phasellus at aliquet ante. Integer ut lacinia arcu. Maecenas volutpat elementum erat ut interdum. Aenean risus mi, aliquet nec tincidunt et, consequat ac felis. """,
      rating: 5.0),
  AReview(
      name: "Etu",
      text:
      """ Fusce accumsan porta libero et sollicitudin. Nullam ac felis sit amet ligula tempor consequat. Praesent interdum leo turpis, eget bibendum quam blandit quis. Phasellus eu arcu vitae elit interdum lacinia fringilla a magna. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Etiam aliquam, orci vitae maximus scelerisque, nunc sapien maximus elit, at mattis erat sem sed purus. Proin ornare sapien eu ipsum semper efficitur. Sed id malesuada mauris, ac pretium arcu. Aliquam egestas id elit in pretium. In hac habitasse platea dictumst. Donec quis porttitor velit.  """,
      rating: 1.0),
];
