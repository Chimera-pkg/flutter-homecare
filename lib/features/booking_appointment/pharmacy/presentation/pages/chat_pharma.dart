import 'package:flutter/material.dart';

class ChatPharma extends StatelessWidget {
  final List<Map<String, dynamic>> chatHistory;
  final TextEditingController chatController;
  final ScrollController scrollController;
  final Function sendMessage;

  ChatPharma({
    required this.chatHistory,
    required this.chatController,
    required this.scrollController,
    required this.sendMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/icons/ic_pharma.png',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "AI Pharmacist",
                  style: TextStyle(
                    color: Color(0xFF35C5CF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: Colors.green,
                      size: 12,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Online",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 160,
            child: ListView.builder(
              itemCount: chatHistory.length,
              shrinkWrap: false,
              controller: scrollController,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (index == 0)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 130.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.lock, color: Color(0xFF5782F1)),
                            Text(
                              "(HIPAA Privacy)",
                              style: TextStyle(
                                color: Color(0xFF5782F1),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 14, right: 14, top: 10, bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!chatHistory[index]["isSender"])
                            CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 240, 240, 240),
                              child: Image.asset(
                                'assets/icons/ic_pharma.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Align(
                              alignment: (chatHistory[index]["isSender"]
                                  ? Alignment.topRight
                                  : Alignment.topLeft),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  color: (chatHistory[index]["isSender"]
                                      ? const Color(0xFF35C5CF)
                                      : Colors.white),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  chatHistory[index]["message"],
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: chatHistory[index]["isSender"]
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              height: 150,
              width: double.infinity,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline_rounded,
                            color: Colors.grey),
                        const SizedBox(width: 5),
                        const Text(
                          "Need Help? ",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => PersonalPage()),
                            // );
                          },
                          child: const Text(
                            "Request help from the Pharmacist",
                            style: TextStyle(
                              color: Color(0xFF35C5CF),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    hintText: 'Write your message',
                                    hintStyle: TextStyle(
                                      color: Color(0xFFA1A1A1),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                  ),
                                  controller: chatController,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.mic_none_outlined,
                                    color: Colors.grey),
                                onPressed: () {
                                  // Add your mic button logic here
                                },
                              ),
                              IconButton(
                                color: const Color(0xFF35C5CF),
                                icon: const Icon(
                                  Icons.send,
                                ),
                                onPressed: () {
                                  sendMessage();
                                  // Add your send message logic here
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 4.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
