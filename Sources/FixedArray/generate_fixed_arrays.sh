#!/bin/zsh

# Check arguments
if [ $# -ne 1 ]; then
    echo "Usage: $0 <max count>"
    exit 1
fi

max_count=$1

# Ensure max_count is a positive integer (> 0)
if ! [[ "$max_count" =~ ^[0-9]+$ ]] || [ "$max_count" -le 0 ]; then
    echo "Error: max_count must be an integer greater than 0"
    exit 1
fi

# Resolve script directory
script_dir="$(cd "$(dirname "$0")" && pwd)"
file="$script_dir/FixedArraySize+Generated.swift"

# Check if file exists
if [ ! -f "$file" ]; then
    echo "Error: FixedArray+Sizes.swift not found in $script_dir"
    exit 1
fi

# Keep everything up to and including the "/// START" line
# BSD sed requires printing the lines we want instead of deleting
sed -i '' '/^\/\/\/# DO NOT CHANGE!!/q' "$file"
echo "" >> "$file"

echo "max_count set to: $max_count"

width=${#max_count}

for ((i=1; i<=max_count; i++)); do
    pad=$((width - ${#i}))
    printf "public enum FixedArraySize%d: %*sFixedArraySize { public static var count: Int { %*s%d } }\n" "$i" "$pad" "" "$pad" "" "$i" >> "$file"
done
echo "" >> "$file"

for ((i=1; i<=max_count; i++)); do
    pad=$((width - ${#i}))
    printf "public typealias FixedArray%d%*s<Element> = FixedArray<FixedArraySize%d, %*sElement>\n" "$i" "$pad" "" "$i" "$pad" "" >> "$file"
done
echo "" >> "$file"

echo "extension FixedArray {" >> "$file"

for ((i=1; i<=max_count; i++)); do
    # pad=$((width - ${#i}))
    printf "    public init(\n        " >> "$file"

    for ((j=1; j<=i; j++)); do
        if (( j > 1 && (j - 1) % 4 == 0 )); then
            printf "\n        " >> "$file"
        fi

        printf "_ _%d: Element" "$j" >> "$file"

        if [ "$j" -ne "$i" ]; then
            printf ", " >> "$file"
        fi
    done

    printf "\n    ) where Size == FixedArraySize%d {\n" "$i" >> "$file"
    printf "        self.init(e: " >> "$file"

    for ((j=1; j<=i; j++)); do
        if (( j > 1 && j + 3 <= i && (j - 1) % 12 == 0 )); then
            printf "\n                  " >> "$file"
        fi

        printf "_%d" "$j" >> "$file"

        if [ "$j" -ne "$i" ]; then
            printf ", " >> "$file"
        fi
    done

    printf ")\n    }\n" >> "$file"

    if [ "$i" -ne "$max_count" ]; then
        printf "    \n" >> "$file"
    fi
done

# public init(_ _1: Element) where Size == FixedArraySize1 { self.init(fileprivateElements: _1) }



echo "}" >> "$file"
