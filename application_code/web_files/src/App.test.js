import { render, screen } from '@testing-library/react';
import App from './App';

test('renders App component with navigation', () => {
  render(<App />);
  const burgerElement = screen.getByLabelText(/Toggle menu/i);
  expect(burgerElement).toBeInTheDocument();
});
