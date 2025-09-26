import { render, screen } from '@testing-library/react';
import { HashRouter } from 'react-router-dom';
import App from './App';

test('renders App component with navigation', () => {
  render(
    <HashRouter>
      <App />
    </HashRouter>
  );
  const burgerElement = screen.getByLabelText(/Toggle menu/i);
  expect(burgerElement).toBeInTheDocument();
});
