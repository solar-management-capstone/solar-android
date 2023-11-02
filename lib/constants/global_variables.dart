String uri = 'https://solarcapstone.azurewebsites.net/api';

class Item {
  final String label;
  final String value;

  Item({required this.label, required this.value});
}

List<Item> listGenders = <Item>[
  Item(label: 'Nam', value: 'true'),
  Item(label: 'Nữ', value: 'false')
];
