import java.io.BufferedReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Day22 {
    public static void main(String[] args) {
        System.out.println("Hello world");
        List<List<Integer>> lines = readLines("input.txt");
        assert lines != null;
        for(List<Integer> line: lines) {
            System.out.println(line);
        }
        System.out.println("Part 1: " + part1(lines));
        System.out.println("Part 2: " + part2(lines));
    }

    private static int part1(List<List<Integer>> coordinates) {
        int axis_length = 110;
        ArrayList<ArrayList<ArrayList<Integer>>> space = new ArrayList<>(axis_length);
        for (int i = 0; i < axis_length; i++) {
            space.add(new ArrayList<>(axis_length));
            for (int j = 0; j < axis_length; j++){
                space.get(i).add(new ArrayList<>(axis_length));
                for (int k = 0; k < axis_length; k++)
                    space.get(i).get(j).add(0);
            }
        }
        for(List<Integer> coordinate : coordinates) {
            if (coordinate.stream().mapToInt(Math::abs).filter(i-> i>50).count() != 0) continue;
            int value = coordinate.get(0);
            for(int x = coordinate.get(1); x <= coordinate.get(2); x++)
                for(int y = coordinate.get(3); y <= coordinate.get(4); y++)
                    for(int z = coordinate.get(5); z <= coordinate.get(6); z++)
                        space.get(x+50).get(y+50).set(z+50, value);
        }
        return space.stream()
                .map(area ->
                area.stream()
                        .map(line ->
                                line.stream().mapToInt(i->i).sum())
                        .mapToInt(i->i).sum())
                .mapToInt(i->i)
                .sum();
    }

    private static long part2(List<List<Integer>> coordinates) {
        List<List<Integer>> existingCubes = new ArrayList<>();
        for (List<Integer> coordinate: coordinates) {
            int value = coordinate.get(0),
                    lowX = coordinate.get(1), highX = coordinate.get(2),
                    lowY = coordinate.get(3), highY = coordinate.get(4),
                    lowZ = coordinate.get(5), highZ = coordinate.get(6);
            for(int i = 0; i < existingCubes.size(); i++) {
                List<Integer> existingCube =  existingCubes.get(i);
                int ElowX = existingCube.get(0), EhighX = existingCube.get(1),
                        ElowY = existingCube.get(2), EhighY = existingCube.get(3),
                        ElowZ = existingCube.get(4), EhighZ = existingCube.get(5);
                if (lowX > EhighX || highX < ElowX ||
                        lowY > EhighY || highY < ElowY ||
                        lowZ > EhighZ || highZ < ElowZ) continue;
                existingCubes.remove(existingCube);
                i--;
                if (lowX > ElowX) existingCubes.add(new ArrayList<>(Arrays.asList(
                        ElowX, lowX-1, ElowY, EhighY, ElowZ, EhighZ
                )));
                if (highX < EhighX) existingCubes.add(new ArrayList<>(Arrays.asList(
                        highX+1, EhighX, ElowY, EhighY, ElowZ, EhighZ
                )));

                if (lowY > ElowY) existingCubes.add(new ArrayList<>(Arrays.asList(
                        Math.max(ElowX, lowX), Math.min(EhighX, highX), ElowY, lowY-1, ElowZ, EhighZ
                )));
                if (highY < EhighY) existingCubes.add(new ArrayList<>(Arrays.asList(
                        Math.max(ElowX, lowX), Math.min(EhighX, highX), highY+1, EhighY, ElowZ, EhighZ
                )));

                if (lowZ > ElowZ) existingCubes.add(new ArrayList<>(Arrays.asList(
                        Math.max(ElowX, lowX), Math.min(EhighX, highX),
                        Math.max(ElowY, lowY), Math.min(EhighY, highY),
                        ElowZ, lowZ-1
                )));
                if (highZ < EhighZ) existingCubes.add(new ArrayList<>(Arrays.asList(
                        Math.max(ElowX, lowX), Math.min(EhighX, highX),
                        Math.max(ElowY, lowY), Math.min(EhighY, highY),
                        highZ+1, EhighZ
                )));
            }
            if (value==1) {
                existingCubes.add(new ArrayList<>(Arrays.asList(
                        Math.min(highX, lowX), Math.max(lowX, highX),
                        Math.min(highY, lowY), Math.max(lowY, highY),
                        Math.min(highZ, lowZ), Math.max(lowZ, highZ)
                )));
            }
        }
        long total = 0L;
        for (List<Integer> cube: existingCubes) {
            long lowX = cube.get(0), highX = cube.get(1),
                    lowY = cube.get(2), highY = cube.get(3),
                    lowZ = cube.get(4), highZ = cube.get(5);
            total += ((highX - lowX) + 1) * ((highY - lowY) + 1) * ((highZ - lowZ) + 1);
        }
        return total;
    }

    private static List<List<Integer>> readLines(String filename) {
        Path path = Paths.get(filename);
        try(Stream<String> lines = Files.lines(path)) {
            return lines.map(s ->
                    Arrays.stream(s.replaceAll("on ", "1,").replaceAll("off ", "0,").split("[=,.]"))
                            .filter(si-> Pattern.matches("[\\-]?[0-9]+", si))
                            .map(Integer::parseInt)
                            .collect(Collectors.toList()))
                    .collect(Collectors.toList());
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }
}
