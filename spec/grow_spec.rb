
#
# spec'ing h.js
#
# Sat Jan 28 15:46:46 JST 2017
#

require 'spec_helpers.rb'


describe 'H' do

  describe '.grow' do

    it 'grows trees' do

      html = run(%{
        return H.grow(function() {

          div('toto');

        }).outerHTML;
      })

      expect(html).to eq(%{
        <div>toto</div>
      }.strip)
    end

    it 'grows trees with ids and classes' do

      html = run(%{
        return H.grow(function() {

          div('#nada.surf', 'toto', '.hell');

        }).outerHTML;
      })

      expect(html).to eq(%{
        <div id="nada" class="surf hell">toto</div>
      }.strip)
    end

    it 'grows trees with subtrees' do

      html = run(%{
        return H.grow(function() {

          div('#nada.surf',
            span('.a', 'alpha'),
            'toto',
            span('.b', 'bravo'));

        }).outerHTML;
      })

      expect(html).to eq(%{
        <div id="nada" class="surf">
          <span class="a">alpha</span>
          toto
          <span class="b">bravo</span>
        </div>
      }.strip.gsub(/>\s+/, '>').gsub(/\s+</, '<'))
    end

    it 'skips subtrees when `false`' do

      html = run(%{
        return H.grow(function() {

          div('#nada.surf',
            span('.a', 'alpha'),
            span('.b', 'bravo'),
            div('.c',
              false,
              span('.d', 'delta'),
              span('.e', 'echo')))

        }).outerHTML;
      })

      expect(html).to eq(%{
        <div id="nada" class="surf">
          <span class="a">alpha</span>
          <span class="b">bravo</span>
        </div>
      }.strip.gsub(/>\s+/, '>').gsub(/\s+</, '<'))
    end
  end

  describe '.makeTemplate' do

    it 'can be used for templating' do

      html = run(%{
        var template = H.makeTemplate(function(h) {
          div('#id', '' + h.id);
        });
        return template({ id: 123 }).outerHTML;
      })

      expect(html).to eq(%{
        <div id="id">123</div>
      }.strip.gsub(/>\s+/, '>').gsub(/\s+</, '<'))
    end
  end
end

