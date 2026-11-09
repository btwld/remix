import React from 'react';
import {createRoot} from 'react-dom/client';
import {Calendar,RangeCalendar,DatePicker,DateRangePicker,DateField} from '@heroui/react';
import {CalendarDate} from '@internationalized/date';
import './calendar.css';
const date=d=>new CalendarDate(2026,11,d);
function Grid({C}) {return <><C.Header><C.Heading/><C.NavButton slot="previous"/><C.NavButton slot="next"/></C.Header><C.Grid><C.GridHeader>{day=><C.HeaderCell>{day}</C.HeaderCell>}</C.GridHeader><C.GridBody>{day=><C.Cell date={day}/>}</C.GridBody></C.Grid></>;}
function Inline({range=false,disabled=false}) {const C=range?RangeCalendar:Calendar;return <section data-case={(range?'range-calendar':'calendar')+(disabled?'-disabled':'')}><C aria-label="Visit date" defaultValue={range?{start:date(10),end:date(13)}:date(10)} isDisabled={disabled}><Grid C={C}/></C></section>;}
function Picker({range=false}) {const P=range?DateRangePicker:DatePicker;const C=range?RangeCalendar:Calendar;return <section data-case={range?'date-range-picker':'date-picker'}><P aria-label="Stay" defaultValue={range?{start:date(10),end:date(13)}:date(10)}><DateField.Group><DateField.Input slot={range?'start':undefined}>{segment=><DateField.Segment segment={segment}/>}</DateField.Input>{range&&<><DateRangePicker.RangeSeparator/><DateField.Input slot="end">{segment=><DateField.Segment segment={segment}/>}</DateField.Input></>}<DateField.Suffix><P.Trigger><P.TriggerIndicator/></P.Trigger></DateField.Suffix></DateField.Group><P.Popover><C aria-label="Choose date"><Grid C={C}/></C></P.Popover></P></section>;}
createRoot(document.getElementById('root')).render(<main><Inline/><Inline range/><Inline disabled/><Inline range disabled/><Picker/><Picker range/></main>);
