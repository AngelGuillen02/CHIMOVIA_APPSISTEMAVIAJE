import 'package:flutter/material.dart';


class FilaColaboradores extends StatefulWidget {

  final String label;
  final String value;
  const FilaColaboradores({super.key, required this.label, required this.value});

  @override
  State<FilaColaboradores> createState() => _FilaColaboradoresState();
}

class _FilaColaboradoresState extends State<FilaColaboradores> {
  @override
  Widget build(BuildContext context) {
    return _buildInfoRow(widget.label, widget.value);
  }
}

Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(child: Text(value, style: TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }