import React from 'react';
import {createRoot} from 'react-dom/client';
import {Label, Slider} from '@heroui/react';
import './range_slider.css';

function Range({disabled = false}) {
  return <div className="case" data-case={disabled ? 'slider-range-disabled' : 'slider-range'}>
    <Slider defaultValue={[20,60]} isDisabled={disabled}>
      <Label>Nightly price</Label><Slider.Output/>
      <Slider.Track><Slider.Fill/>
        <Slider.Thumb index={0} aria-label="Minimum price"/>
        <Slider.Thumb index={1} aria-label="Maximum price"/>
      </Slider.Track>
    </Slider>
  </div>;
}
createRoot(document.getElementById('root')).render(<main><Range/><Range disabled/></main>);
