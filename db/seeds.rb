# frozen_string_literal: true

### Create authors
#
authors = [
  { name: "Vissarion", surname: "Tingaev", patronymic: "Arturovich" },
  { name: "Selivan", surname: "Neronov", patronymic: "Evdokimovich" },
  { name: "Andron", surname: "Mosin", patronymic: "Kazimirovich" },
  { name: "Oskar", surname: "Mamchic", patronymic: "Arsentievich" },
  { name: "Epifan", surname: "Vidov", patronymic: "Protasovich" },

  { name: "Zenon", surname: "Bulochnikov", patronymic: "Vilgelmovich" },
  { name: "Elisej", surname: "Venecianov", patronymic: "Titovich" },
  { name: "Zenon", surname: "Podgaeckij", patronymic: "Vilgelmovich" },
  { name: "Adrian", surname: "Ishtov", patronymic: "Evlampievich" },
  { name: "Aleksej", surname: "Ishtov", patronymic: "Evlampievich" },

  { name: "Azar", surname: "Golubockij", patronymic: "Lazarevich" },
  { name: "Harlamp", surname: "Vorobej", patronymic: "Haritonievich" },
  { name: "Trifon", surname: "Podbereznij", patronymic: "Diomidovich" },
  { name: "Onisim", surname: "Lesin", patronymic: "Abramovich" },
  { name: "Vikul", surname: "Kazin", patronymic: "Terentievich" },

  { name: "Sergej", surname: "Dorin", patronymic: nil },
  { name: "Karp", surname: "Ribka", patronymic: nil },
  { name: "Afanasij", surname: "Isserlis", patronymic: nil },
  { name: "Onisim", surname: "Novickij", patronymic: nil },
  { name: "Vikul", surname: "Tolstonogov", patronymic: nil },

  { name: "Erotidin", surname: nil, patronymic: nil },
  { name: "Mokij", surname: nil, patronymic: nil },
  { name: "Abakum", surname: nil, patronymic: nil },
  { name: "Pankrat", surname: nil, patronymic: nil },
  { name: "Ivan", surname: nil, patronymic: nil }
].map { |author_attrs| Author.find_or_create_by!(author_attrs) }

### Create courses
#
courses = [
  { title: "Math" },
  { title: "Climbing" },
  { title: "Programming 101" },
  { title: "BrainWorkout" },
  { title: "History" },

  { title: "MindGames" },
  { title: "AliDeal" },
  { title: "AmpHealth" },
  { title: "Legend Mind" },
  { title: "Brain Web" },

  { title: "Spark X" },
  { title: "Online Up" },
  { title: "Online Talent" },
  { title: "TryLearnIt" },
  { title: "MyTeacher" },

  { title: "LearnIt" },
  { title: "Online Iconic" },
  { title: "Courseella" },
  { title: "U-Beginner" },
  { title: "Mastery Center" },

  { title: "Onlineify" },
  { title: "Edmusing" },
  { title: "Ulearn IT" },
  { title: "CosmicMind" },
  { title: "Course Develop" }
].map { |course_attrs| Course.find_or_create_by!(course_attrs.merge(author: authors.sample)) }

### Create competencies
#
30.times.map do |i|
  Competency.find_or_initialize_by(title: "Competency ##{i}").update!(course: courses.sample)
end
