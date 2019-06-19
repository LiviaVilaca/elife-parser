RSpec.describe ElifeParser::Term do
  shared_examples "a matching term" do |text|
    it "matchs #{text}" do
      expect(subject.match?(ElifeParser::Text.new(text))).to be_truthy
    end
  end

  shared_examples "a not matching term" do |text|
    it "doesn't match #{text}" do
      expect(subject.match?(ElifeParser::Text.new(text))).to be_falsey
    end
  end

  # mover esse tree pra outro canto
  describe "tree" do
    it "should create tree" do
      skip
      p ElifeParser.tree(
        "(manoel OR (quirino neto \"k n\") OR silva OR (foo bar baz))  -teste -\"+foo  bar\""
      )
    end
  end


  describe "match" do
    context "rato OR roma" do
      subject {
        ElifeParser.tree("rato OR roma")
      }

      it_behaves_like "a matching term", "O rato roeu"
      it_behaves_like "a matching term", "a roupa de roma"
      it_behaves_like "a matching term", "rei de roma"
      it_behaves_like "a not matching term", "roeu a roupa"
    end

    context "rat* OR roma" do
      subject {
        ElifeParser.tree("rat* OR roma")
      }

      it_behaves_like "a matching term", "A rata roeu"
      it_behaves_like "a matching term", "O rato roeu"
      it_behaves_like "a matching term", "a roupa de roma"
      it_behaves_like "a matching term", "rei de roma"
      it_behaves_like "a not matching term", "roeu a roupa"
    end

    context "futebol de (homem OR mulher)" do
      subject {
        ElifeParser.tree("futebol de (homem OR mulher)")
      }

      it_behaves_like "a matching term", "Futebol de Homem"
      it_behaves_like "a matching term", "Futebol de Mulher"
      it_behaves_like "a not matching term", "Futebol de Cegos"
    end

    context "gosto de *can*" do
      subject {
        ElifeParser.tree("gosto de *can*")
      }

      it_behaves_like "a matching term", "Gosto de cano"
      it_behaves_like "a matching term", "Gosto de encanamento"
      it_behaves_like "a not matching term", "Gosto de bolo"
    end

    context "(gosto de *can*) -\"non creio\"" do
      subject {
        ElifeParser.tree("(gosto de *can*) -\"non creio\"")
      }

      it_behaves_like "a matching term", "Gosto de cano"
      it_behaves_like "a matching term", "Gosto de encanamento"
      it_behaves_like "a not matching term", "Gosto de encanamento, non creio"
      it_behaves_like "a not matching term", "Gosto de bolo"
    end

    context "(Test OR 🙈 OR 🙊) -🙉" do
      subject {
        ElifeParser.tree("(Test OR 🙈 OR 🙊) -🙉")
      }

      it_behaves_like "a matching term", "Test Gosto de cano"
      it_behaves_like "a not matching term", "Gosto de encanamento"
      it_behaves_like "a matching term", "🙈"
      it_behaves_like "a matching term", "🙊"
      it_behaves_like "a not matching term", "🙊 🙉"
    end

    context "👨🏿" do
      subject {
        ElifeParser.tree("👨🏿")
      }

      it_behaves_like "a matching term", "👨🏿"
      it_behaves_like "a matching term", "👨"
    end
  end
end
