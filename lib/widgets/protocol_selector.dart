import 'package:flutter/material.dart';

import '../models/fasting_protocol.dart';

class ProtocolSelector extends StatelessWidget {
  final FastingProtocol selectedProtocol;
  final ValueChanged<FastingProtocol> onProtocolSelected;
  final bool enabled;

  const ProtocolSelector({
    super.key,
    required this.selectedProtocol,
    required this.onProtocolSelected,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: FastingProtocol.protocols.map((protocol) {
        final isSelected = protocol == selectedProtocol;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: OutlinedButton(
              onPressed: enabled
                  ? () {
                      onProtocolSelected(protocol);
                    }
                  : null,
              style: OutlinedButton.styleFrom(
                backgroundColor: isSelected
                    ? Theme.of(context).colorScheme.primaryContainer
                    : null,
                side: BorderSide(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                ),
              ),
              child: Text(protocol.name),
            ),
          ),
        );
      }).toList(),
    );
  }
}