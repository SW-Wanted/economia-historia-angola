import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _activeFilter = 'Todos'; // 'Todos', 'Escritor', 'Admin'

  final List<Map<String, dynamic>> _users = [
    {
      'id': '1',
      'name': 'Ana Paula Lourenço',
      'email': 'ana.lourenco@economia.ao',
      'role': 'Admin',
      'avatarUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBvcTB4dtUzOeIp6YaKKNnIHmJZvHqAgIIG96u5QmLZpYprjTV6uUaYfnYvYaPPkrUI8KAHIACqTw6N54xTJG-m3k39f-QURKZI-1KC3MdqZ7GRhXo4yiWVYv6wBrmLfhDM4nPQKYNOMhkBsG4xgohVGLARXgbJnkO29au4Wf3UTh7SYQ3ZG5ERW8L-2rXNH3za28AHTX7PX2G6KCVkhTMH1U9REpzdHZO7ffhvwz0d3S4Y47wkydBHlO9kS3V4rfcgzdUsiC0uEzk',
    },
    {
      'id': '2',
      'name': 'Kelson Manuel',
      'email': 'kelson.m@historia.ao',
      'role': 'Escritor',
      'avatarUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuD2W2VkKKLeHwKKnhoZ2P1Gpt_OK2cXPlrVmWEDmt8gb3yO8DCWQsRI8fikKa-hUOS9VBYMGIvlgFMNw50mleHcpLq27tD27MDoxb-hHlJT1mQ6UtxZEyERBQneez4UfFFqi_62zNu2YeVclIPH8aH1jltv-Ov8njMZQtfBu0SDEyBR0T8krrrL4Qc1wxhcC2ReZanONNTWkn0sjmEQMCAwhEdrXceOodEzpIAS6jmRpVjsCTgg6E7xIVZFjBJ-Vf7hZcCOKyFNTrs',
    },
    {
      'id': '3',
      'name': 'Isabel dos Santos',
      'email': 'isabel.santos@academia.ao',
      'role': 'Escritor',
      'avatarUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAe9ShHY2wIPLt8WOMWdjYlg7DHudrQRGqMnaYP8PZ4E-P3iLLGne8_LJvy20DbWeNB0RyHuR9EG_6wi9Zmd5A_maY8YiziwsQN0LhAav9KGhJLExsIT2G7UVjkYdODLhDbvtd5mVVwCXRPvdSJ3EvJe76CQmXgDT5iGcVLjVSwDDK0e53_hPi2GE-jmjVkc0oGqp9vy4p9qPTCzzfOvGrJWyYmWr7qbtYaQUhRTTKxgsgKACTr_EEJb6UiragpuhGwvsZ8LC8dubU',
    },
    {
      'id': '4',
      'name': 'Domingos Zau',
      'email': 'domingos.z@minfin.gov.ao',
      'role': 'Leitor',
      'avatarUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDezB4qMqEZ7xUod-WQ3zsPXr049_kpM6cozgvKCx9_7UD9gtsl55sIcFYoceZbTUWDXVVfmDfsocUlDEj-xzMSIeJBv_ecNL1ubuKY8641CZ6Jbl5Aoo2JjX71WJSZDZwV7zcJpsjyQ1ye5LxxrKyyYrM9hPJyr7WSnWdZnNCcKrXvp2k7OgdUixttgpN66pG9Vgzm6VUgQCyoO0XEhkil5H_-R7ZQAi_qO5DFVQErjCWS-IQzXLBjaQ5Mpy1vSjEcniJ6JC_syG0',
    }
  ];

  List<Map<String, dynamic>> _getFilteredUsers() {
    return _users.where((user) {
      final matchesSearch = user['name']!.toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user['email']!.toString().toLowerCase().contains(_searchQuery.toLowerCase());
      
      if (_activeFilter == 'Todos') {
        return matchesSearch;
      }
      return matchesSearch && user['role'] == _activeFilter;
    }).toList();
  }

  void _showActionMenu(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ações para ${user['name']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.edit, color: AppColors.tertiary),
                title: const Text('Promover Utilizador'),
                onTap: () {
                  Navigator.pop(context);
                  _changeUserRole(user['id'], 'Admin');
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: AppColors.error),
                title: const Text('Bloquear Acesso', style: TextStyle(color: AppColors.error)),
                onTap: () {
                  Navigator.pop(context);
                  _blockUser(user['name']);
                },
              ),
              const Divider(color: AppColors.outlineVariant),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _changeUserRole(String id, String newRole) {
    setState(() {
      final index = _users.indexWhere((u) => u['id'] == id);
      if (index != -1) {
        _users[index]['role'] = newRole;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Utilizador promovido para $newRole.'),
        backgroundColor: AppColors.tertiary,
      ),
    );
  }

  void _blockUser(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Utilizador $name bloqueado com sucesso.'),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _getFilteredUsers();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F0),
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        elevation: 1,
        shadowColor: Colors.black12,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Gestão de Utilizadores',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.secondary),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryContainer, width: 1.5),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCUK29nobhgPtNHjP0oCtuP-DT8cDI0tNqsUuzbO6fR9xMis4w3VU9FKty5YOTMA9Ri6SVeXmT989LOEkqYp59DpFt7xcf4ySVBkeMPBLQrdtTCdFbOsfacFH47dfc9EFer65TC6Io2NycAt5-RBRQ2fM2HbtQcKIrKQwwesvADW0NYAEsSnogNUIercKrQ9Zn_YNEgaHCtVDi3KjidnKo1Wlwm5RnQPqUIhjcZEwjF3cL5cwZMLl9pRIr-h8E0Wu4qxG-Qx2TlPYM',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Input
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      color: const Color(0x0D000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Procurar por nome ou email...',
                    hintStyle: TextStyle(color: AppColors.secondary, fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: AppColors.secondary),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Filter Chips
              Row(
                children: [
                  _buildFilterChip('Todos'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Escritor'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Admin'),
                ],
              ),
              const SizedBox(height: 24),

              // Users List & Contextual Cards
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredUsers.length + 1, // +1 for the Jindungo card
                itemBuilder: (context, index) {
                  // Put the Jindungo safety card after the 3rd user (index 3) or at the end if fewer
                  final targetJindungoIndex = filteredUsers.length >= 3 ? 3 : filteredUsers.length;

                  if (index == targetJindungoIndex) {
                    return _buildSafetyTipCard();
                  }

                  // Adjust index if we are past the Jindungo card
                  final userIndex = index > targetJindungoIndex ? index - 1 : index;
                  if (userIndex >= filteredUsers.length) return const SizedBox.shrink();

                  final user = filteredUsers[userIndex];
                  return _buildUserCard(user);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isActive = _activeFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.tertiary : AppColors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    final role = user['role'].toString();
    final roleColor = switch (role) {
      'Admin' => AppColors.primaryContainer,
      'Escritor' => AppColors.tertiaryContainer,
      _ => AppColors.secondary,
    };
    final roleTextColor = switch (role) {
      'Admin' => Colors.white,
      'Escritor' => AppColors.onTertiaryContainer,
      _ => AppColors.onSecondaryContainer,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: const Color(0x0D000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceVariant,
                  image: DecorationImage(
                    image: NetworkImage(user['avatarUrl'].toString()),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user['name'].toString(),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    user['email'].toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: roleColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      role.toUpperCase(),
                      style: TextStyle(
                        color: roleTextColor,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.secondary),
            onPressed: () => _showActionMenu(user),
          ),
        ],
      ),
    );
  }
  Widget _buildSafetyTipCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Row(
                children: [
                  Icon(Icons.bolt, color: Colors.yellow, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'CONTROLE DE ACESSO',
                    style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Dica de Segurança',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Como administrador, lembre-se de revisar periodicamente os privilégios dos escritores para manter a integridade histórica dos dados.',
                style: TextStyle(
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Positioned(
            right: -10,
            bottom: -10,
            child: Opacity(
              opacity: 0.1,
              child: Transform.scale(
                scale: 1.3,
                child: const Icon(
                  Icons.admin_panel_settings,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
