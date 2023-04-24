class AChat {
  String text;
  String date;
  String time;
  bool is_sender;

  AChat({this.text,this.date="JAN 05, 2021", this.time: "10:02 AM", this.is_sender});
}

final List<AChat> chatList = [
  AChat(
      text:
          "Hey, do you have 3rd party charger of iPhone. I want to buy a black color.",
      is_sender: true),
  AChat(text: "A grey colored one will be okay...", is_sender: true),
  AChat(
      text:
          "We have a series of collection of iPhone charger. You will find every color iPhone is available. Please check all products of our shop. Thank you for your interest.",
      is_sender: false),
  AChat(
      text: "I haven't got my order yet. Could you please help.",
      is_sender: true),
  AChat(text: "Send us your order no.", is_sender: false),
  AChat(text: "20201215-12034564", is_sender: true),
  AChat(
      text: "You will hopefully get it tomorrow. Thanks for staying with us.",
      is_sender: false),
  AChat(
      text: "Thanks.",
      is_sender: true),
  AChat(
      text: "Please visit our shop regularly. We are offering the highest quality products all time.",
      is_sender: false),
  AChat(
      text: "I haven't got my order yet. Could you please help.",
      is_sender: true),
  AChat(
      text: "You will hopefully get it tomorrow. Thanks for staying with us.",
      is_sender: false),
  AChat(
      text:
      "Hey, do you have 3rd party charger of iPhone. I want to buy a black color.",
      is_sender: true),
  AChat(text: "A grey colored one will be okay...", is_sender: true),
  AChat(
      text:
      "We have a series of collection of iPhone charger. You will find every color iPhone is available. Please check all products of our shop. Thank you for your interest.",
      is_sender: false),
  AChat(
      text: "I haven't got my order yet. Could you please help.",
      is_sender: true),
  AChat(
      text: "Ok",
      is_sender: false),

];
