class Job {
  final String id;
  final String name;
  final String company;
  final String? image;
  final String type;
  final String location;
  final String stipend;
  final String duration;
  final String applyBy;
  final String details;
  final EligibilityCriteria eligibilityCriteria;
  final Contact contact;
  final String website;

  Job({
    required this.id,
    required this.name,
    required this.company,
    this.image,
    required this.type,
    required this.location,
    required this.stipend,
    required this.duration,
    required this.applyBy,
    required this.details,
    required this.eligibilityCriteria,
    required this.contact,
    required this.website,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      company: json['company'] ?? '',
      image: json['image'] ?? "",
      type: json['type'] ?? '',
      location: json['location'] ?? '',
      stipend: json['stipend'] ?? '',
      duration: json['duration'] ?? '',
      applyBy: json['applyBy'] ?? json['deadline']?.toString() ?? '',
      details: json['details'] ?? json['description'] ?? '',
      eligibilityCriteria: json['eligibilityCriteria'] != null
          ? EligibilityCriteria.fromJson(json['eligibilityCriteria'])
          : EligibilityCriteria(education: '', cgpa: '', skills: ''),
      contact: json['contact'] != null
          ? Contact.fromJson(json['contact'])
          : Contact(name: '', phoneNo: ''),
      website: json['website'] ?? json['links']?.first ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'company': company,
      'image': image ?? "",
      'type': type,
      'location': location,
      'stipend': stipend,
      'duration': duration,
      'applyBy': applyBy,
      'details': details,
      'eligibilityCriteria': eligibilityCriteria.toJson(),
      'contact': contact.toJson(),
      'website': website,
    };
  }
}

class Contact {
  final String name;
  final String phoneNo;

  Contact({
    required this.name,
    required this.phoneNo,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'],
      phoneNo: json['phoneNo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNo': phoneNo,
    };
  }
}

class EligibilityCriteria {
  final String education;
  final String cgpa;
  final String skills;

  EligibilityCriteria(
      {required this.education, required this.cgpa, required this.skills});

  factory EligibilityCriteria.fromJson(Map<String, dynamic> json) {
    return EligibilityCriteria(
        education: json['education'],
        cgpa: json['cgpa'],
        skills: json['skills']);
  }

  Map<String, dynamic> toJson() {
    return {'education': education, 'cgpa': cgpa, 'skills': skills};
  }
}
