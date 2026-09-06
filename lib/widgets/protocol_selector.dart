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
                foregroundColor: isSelected
                    ? const Color(0xFFFFFFFF)
                    : Theme.of(context).colorScheme.onSurface,
                backgroundColor: isSelected
                    ? const Color(0xFF2E7D5B)
                    : null,
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF63C174)
                      : Theme.of(context).colorScheme.outline,
                  width: isSelected ? 1.5 : 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                protocol.name,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
