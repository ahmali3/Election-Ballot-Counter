package cmpt383;
import java.io.*;
import java.util.*;

/**
 * @author Ahmed Ali
 * CMPT 383
 * Program that tracks the number of ballots
 */

public class final_project {
     static final Map<String, Integer> cand = new HashMap();
     static BufferedReader b;
     static int ballots = 0;
     static int empty = 0;
     static int full = 0;
     static String line;

     // File reading (obtained from https://stackoverflow.com/questions/3844307/how-to-read-file-from-relative-path-in-java-project-java-io-file-cannot-find-th)
     static BufferedReader fileReader(String input) throws IOException {
        File file = new File(System.getProperty("user.dir") + "\\src\\cmpt383\\" + input);
        FileInputStream i = new FileInputStream(file);
        InputStreamReader r = new InputStreamReader(i);
        return new BufferedReader(r);
    }

     static void voteCounter(String input) throws IOException {
        b = fileReader(input);
        while ((line = b.readLine()) != null) {
            if (!line.equals("none")) {
                Map<String, Integer> tempMap = new HashMap();
                String[] ballots = line.split(" ");
                for (String ballot : ballots) {
                    if (tempMap.containsKey(ballot)) continue;
                    else tempMap.put(ballot, 1);

                    cand.put(ballot, cand.getOrDefault(ballot, 0) + 1);
                }
            } else empty++;
            ballots++;
        }
    }

     static void fullBallots(String input) throws IOException {
        b = fileReader(input);
        while ((line = b.readLine()) != null) {
            if (!line.equals("none")) {
                int tempCounter = 0;
                Map<String, Integer> tempMap = new HashMap();
                String[] ballots = line.split(" ");
                for (String ballot : ballots) {
                    if (tempMap.containsKey(ballot)) continue;
                    else {
                        tempMap.put(ballot, 1);
                        tempCounter++;
                    }
                    if (tempCounter == cand.size()) full++;
                }
            }
        }
    }

    public static void main(String[] args) throws IOException {
        Scanner input = new Scanner(System.in);
        System.out.println("What is the name of the ballot file?");
        String fileName = input.next();

        voteCounter(fileName);
        fullBallots(fileName);

        System.out.println("\nTotal # of ballots: " + ballots + "\n");

        // Printing votes in sorted order (obtained from https://stackoverflow.com/questions/8119366/sorting-hashmap-by-values)
        // Converts the entries into a stream and uses the comparator combinators to sort the values and prints them in a loop
        cand.entrySet().stream().sorted((k1, k2) -> -k1.getValue().compareTo(k2.getValue()))
                .forEach(k -> System.out.println(k.getKey() + ": " + k.getValue()));

        System.out.println("\nempty: " + empty);
        System.out.println("full: " + full);
    }
}