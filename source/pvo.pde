import controlP5.*;

ControlP5 cp5;
PImage img;
ArrayList<PVector> hexCenters = new ArrayList<PVector>(); // Центры групп шестиугольников
boolean imageLoaded = false;
float hexWidth = 80; // Ширина шестиугольника
float hexHeight = 60; // Высота шестиугольника
int trans = 80; // Высота шестиугольника

PGraphics hexLayer; // Слой для отрисовки шестиугольников

void setup() {
  size(1200, 800);
  cp5 = new ControlP5(this);

  // Создаем кнопку для выбора изображения
  cp5.addButton("selectImage")
     .setPosition(10, 10)
     .setSize(120, 30)
     .setLabel("Выбрать фото");

  // Инициализируем слой для шестиугольников
  hexLayer = createGraphics(width, height);
  hexLayer.beginDraw();
  hexLayer.clear();
  hexLayer.endDraw();
}

void draw() {
  background(255);

  // Отображаем изображение, если оно загружено
  if (imageLoaded) {
    image(img, 0, 0);
  }

  // Отображаем слой с шестиугольниками
  image(hexLayer, 0, 0);
}

void mousePressed() {
  if (imageLoaded && mouseButton == LEFT && !isMouseOverButton()) {
    hexCenters.add(new PVector(mouseX, mouseY));
    updateHexLayer();
  } else if (mouseButton == RIGHT) {
    for (int i = hexCenters.size() - 1; i >= 0; i--) {
      PVector center = hexCenters.get(i);
      if (dist(mouseX, mouseY, center.x, center.y) < hexWidth / 2) {
        hexCenters.remove(i);
        updateHexLayer();
        break;
      }
    }
  }
}

void updateHexLayer() {
  hexLayer.beginDraw();
  hexLayer.clear();
  for (PVector center : hexCenters) {
    drawHexagonGroup(hexLayer, center.x, center.y);
  }
  hexLayer.endDraw();
}

void drawHexagonGroup(PGraphics layer, float x, float y) {
  layer.pushMatrix();
  layer.translate(x, y);

  drawHexagon(layer, 0, 0, hexWidth, hexHeight, trans);

  float horizontalOffset = hexWidth * 0.435;
  float verticalOffset = hexHeight * 0.75;

  drawHexagon(layer, -horizontalOffset, -verticalOffset, hexWidth, hexHeight, trans);
  drawHexagon(layer, horizontalOffset, -verticalOffset, hexWidth, hexHeight, trans);
  drawHexagon(layer, -horizontalOffset, verticalOffset, hexWidth, hexHeight, trans);
  drawHexagon(layer, horizontalOffset, verticalOffset, hexWidth, hexHeight, trans);
  drawHexagon(layer, -horizontalOffset * 2, 0, hexWidth, hexHeight, trans);
  drawHexagon(layer, horizontalOffset * 2, 0, hexWidth, hexHeight, trans);
  
  layer.popMatrix();
}

void drawHexagon(PGraphics layer, float x, float y, float width, float height, int alpha) {
  layer.fill(255, 0, 0, alpha);
  layer.noStroke();
  layer.beginShape();
  for (int i = 0; i < 6; i++) {
    float angle = PI / 3 * i - PI / 6;
    float px = x + cos(angle) * (width / 2);
    float py = y + sin(angle) * (height / 2);
    layer.vertex(px, py);
  }
  layer.endShape(CLOSE);
}

// Функция для выбора изображения
void selectImage() {
  selectInput("Выберите изображение", "imageSelected");
}

// Обработчик выбора изображения
void imageSelected(File selection) {
  if (selection == null) {
    println("Изображение не выбрано.");
  } else {
    String path = selection.getAbsolutePath();
    img = loadImage(path);
    imageLoaded = true;
    println("Изображение загружено: " + path);
  }
}

// Проверка, находится ли курсор над кнопкой
boolean isMouseOverButton() {
  return mouseX >= 10 && mouseX <= 130 && mouseY >= 10 && mouseY <= 40;
}
