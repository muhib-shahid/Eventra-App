import 'package:flutter/material.dart';

import '../models/event.dart';

const List<Event> sampleEvents = [
  Event(
    id: '1',
    title: 'Music Beyond Limits',
    category: 'Music',
    location: 'Expo Centre, Lahore',
    date: '15 December 2026',
    price: 'Rs. 2,500',
    description:
        'Experience an unforgettable night of live music, '
        'amazing performances and incredible energy.',
    imageUrl: 'https://images.unsplash.com/photo-1501386761578-eac5c94b800a',
    accentColor: Color(0xFF9B72CF),
  ),
  Event(
    id: '2',
    title: 'Future Tech Summit',
    category: 'Technology',
    location: 'Arfa Software Technology Park, Lahore',
    date: '20 December 2026',
    price: 'Rs. 1,500',
    description:
        'Explore emerging technologies, meet innovators and '
        'discover the future of software and artificial intelligence.',
    imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87',
    accentColor: Color(0xFF5289D9),
  ),
  Event(
    id: '3',
    title: 'Champions Football Cup',
    category: 'Sports',
    location: 'Punjab Stadium, Lahore',
    date: '25 December 2026',
    price: 'Rs. 800',
    description:
        'Watch competitive football and experience the excitement '
        'of a live sporting event.',
    imageUrl: 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211',
    accentColor: Color(0xFF4EAD85),
  ),
  Event(
    id: '4',
    title: 'The Art Experience',
    category: 'Art',
    location: 'Alhamra Arts Council, Lahore',
    date: '28 December 2026',
    price: 'Rs. 500',
    description:
        'Discover creative works, contemporary art and inspiring '
        'visual experiences from emerging artists.',
    imageUrl: 'https://images.unsplash.com/photo-1531058020387-3be344556be6',
    accentColor: Color(0xFFD18A65),
  ),
  Event(
    id: '5',
    title: 'Gaming Arena Championship',
    category: 'Gaming',
    location: 'Emporium Mall, Lahore',
    date: '5 January 2027',
    price: 'Rs. 1,000',
    description:
        'Join gaming enthusiasts for competitive matches, '
        'tournaments and an exciting gaming atmosphere.',
    imageUrl: 'https://images.unsplash.com/photo-1542751371-adc38448a05e',
    accentColor: Color(0xFFB16ACB),
  ),
  Event(
    id: '6',
    title: 'The Food Festival',
    category: 'Food',
    location: 'Greater Iqbal Park, Lahore',
    date: '10 January 2027',
    price: 'Rs. 1,200',
    description:
        'Explore a variety of flavours, food stalls and culinary '
        'experiences at a lively outdoor festival.',
    imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
    accentColor: Color(0xFFD69B51),
  ),
];
